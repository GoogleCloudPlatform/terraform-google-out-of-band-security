/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# -------------------------------------------------------------- #
# INSTANCE-TEMPLATE
# -------------------------------------------------------------- #
resource "google_compute_instance_template" "main" {
  provider = google
  project  = var.project_id

  name_prefix    = format("%s-template", var.naming_prefix)
  can_ip_forward = true
  description    = format("%s instance template", var.naming_prefix)
  region         = var.region
  machine_type   = var.machine_type
  labels         = { deployment = var.naming_prefix }

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network            = google_compute_network.traffic.name
    subnetwork         = google_compute_subnetwork.traffic.id
    subnetwork_project = var.project_id
  }

  network_interface {
    network            = data.google_compute_network.mgmt.id
    subnetwork         = data.google_compute_subnetwork.mgmt.id
    subnetwork_project = var.project_id

    # A Dynamic block that keys off of the public ip boolean to create an ephemeral public ip address.
    dynamic "access_config" {
      for_each = var.create_public_management_ip == true ? [var.create_public_management_ip] : []
      content {}
    }
  }

  # A Dynamic disk block that keys off of the add_protected_network variable containing details of each additional needed by the customer.
  dynamic "network_interface" {
    for_each = var.add_protected_network == true ? [var.add_protected_network] : []
    content {
      network = google_compute_network.protected.name
    }
  }

  metadata = merge(tomap({
    block-project-ssh-keys = var.block_project_ssh_keys
    serial-port-enable     = true
    }),
    var.compute_instance_metadata
  )

  scheduling {
    automatic_restart = false
  }

  lifecycle {
    create_before_destroy = true
  }

  # A Dynamic disk block that keys off of the additional_disks variable containing details of each additional needed by the customer.
  dynamic "disk" {
    for_each = var.additional_disks
    content {
      source      = google_compute_disk.default["${disk.key}.${local.zone}"].name
      auto_delete = false
    }
  }

  service_account {
    scopes = var.scopes
  }
}

# -------------------------------------------------------------- #
# LOCAL VARIABLES
# -------------------------------------------------------------- #
locals {
  additional_disk_per_zone = distinct(flatten([
    for zone in var.zones : [
      for k, v in var.additional_disks : {
        disk_key  = k
        disk_size = v["disk_size"]
        disk_type = v["disk_type"]
        zone      = zone
      }
    ]
  ]))

  # additional disks will be usable in every zone.
  # setting one zone as the key just to assign the source for the instance template disk.
  zone = var.zones[0]

  additional_disk_map = { for entry in local.additional_disk_per_zone : "${entry.disk_key}.${entry.zone}" => entry }
}

# -------------------------------------------------------------- #
# MANAGED-INSTANCE_GROUP
# -------------------------------------------------------------- #
resource "google_compute_region_instance_group_manager" "main" {
  provider                  = google-beta
  name                      = format("%s-mig", var.naming_prefix)
  project                   = var.project_id
  region                    = var.region
  distribution_policy_zones = var.zones
  base_instance_name        = format("%s-instance", var.naming_prefix)

  all_instances_config {
    labels = { deployment = var.naming_prefix }
  }

  version {
    instance_template = google_compute_instance_template.main.id
  }

  update_policy {
    minimal_action  = "REPLACE"
    type            = "PROACTIVE"
    max_surge_fixed = length(var.zones)
    min_ready_sec   = 600
  }
}

# -------------------------------------------------------------- #
# AUTO-SCALER
# -------------------------------------------------------------- #
resource "google_compute_region_autoscaler" "main" {
  provider = google
  name     = format("%s-autoscaler", var.naming_prefix)
  project  = var.project_id
  region   = var.region
  target   = google_compute_region_instance_group_manager.main.id

  autoscaling_policy {
    min_replicas    = var.min_instances
    max_replicas    = var.max_instances
    cooldown_period = 240

    cpu_utilization {
      target = var.cpu_target
    }
  }
}

# -------------------------------------------------------------- #
# FORWARDING-RULE
# -------------------------------------------------------------- #
resource "google_compute_forwarding_rule" "main" {
  provider = google-beta
  name     = format("%s-forwarding-rule", var.naming_prefix)
  project  = var.project_id
  region   = var.region
  labels   = { deployment = var.naming_prefix }

  is_mirroring_collector = true
  load_balancing_scheme  = "INTERNAL"
  backend_service        = google_compute_region_backend_service.main.id
  all_ports              = true

  network    = google_compute_network.traffic.id
  subnetwork = google_compute_subnetwork.traffic.id
}

# -------------------------------------------------------------- #
# INTERNAL-LOAD-BALANCER
# -------------------------------------------------------------- #
resource "google_compute_region_backend_service" "main" {
  provider      = google
  name          = format("%s-backend", var.naming_prefix)
  project       = var.project_id
  region        = var.region
  health_checks = [google_compute_health_check.hc.id]

  backend {
    group = google_compute_region_instance_group_manager.main.instance_group
  }
}

# -------------------------------------------------------------- #
# HEALTH-CHECK
# -------------------------------------------------------------- #
resource "google_compute_health_check" "hc" {
  provider = google
  name     = format("%s-health-check-%s", var.naming_prefix, var.region)
  project  = var.project_id

  check_interval_sec = 3
  timeout_sec        = 2
  tcp_health_check {
    port = var.health_check_port
  }
}

# -------------------------------------------------------------- #
# VPC NETWORKS
# -------------------------------------------------------------- #
data "google_compute_network" "mgmt" {
  project = var.project_id
  name    = var.mgmt_network
}

data "google_compute_subnetwork" "mgmt" {
  project = var.project_id
  name    = var.mgmt_subnet
  region  = var.region
}

resource "google_compute_network" "traffic" {
  provider                = google
  name                    = format("%s-traffic-%s", var.naming_prefix, var.region)
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "traffic" {
  provider      = google
  name          = format("%s-traffic-subnet", var.naming_prefix)
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.traffic.name
  ip_cidr_range = var.traffic_subnet_cidr
}

resource "google_compute_network" "protected" {
  for_each                = var.add_protected_network == true ? { protected_network = var.add_protected_network } : {}
  provider                = google
  name                    = format("%s-protected-%s", var.naming_prefix, var.region)
  project                 = var.project_id
  auto_create_subnetworks = true
}

# -------------------------------------------------------------- #
# PERSISTENT DISK
# -------------------------------------------------------------- #
resource "google_compute_disk" "default" {
  for_each = local.additional_disk_map
  name     = format("%s-%s-disk", var.naming_prefix, each.value.disk_key)
  project  = var.project_id
  size     = each.value.disk_size
  type     = each.value.disk_type
  zone     = each.value.zone
}

