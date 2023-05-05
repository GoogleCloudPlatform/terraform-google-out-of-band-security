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
# VARIABLES
# -------------------------------------------------------------- #

variable "project_id" {
  type        = string
  description = "project resources will be deployed into"
}

variable "naming_prefix" {
  type        = string
  description = "prefix string to be appended in front of all deployed resources so they can be easily traced back to deployment assistant"
}

variable "source_image" {
  type        = string
  description = "source image for firewall instance template"
}
# Fortinet test: "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgtondemand-703-20211208-001-w-license"

# Palo Alto Test: "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-flex-byol-913"

# Cisco Test: "https://www.googleapis.com/compute/v1/projects/cisco-public/global/images/cisco-ftdv-7-1-0-92"

# Corelight Test: "projects/zeekautomation/global/images/zeek-fluentd-golden-image-v1"

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region for deployment"
}

variable "zones" {
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
  description = "Zones for deployment as a comma separated string so it can make it through SLM"
}

variable "traffic_subnet_cidr" {
  type        = string
  default     = "10.127.10.0/24"
  description = "Traffic subnet cidr"
}

variable "mgmt_network" {
  type = string

  default     = "default"
  description = "management vpc name"
}

variable "mgmt_subnet" {
  type        = string
  default     = "default"
  description = "Management subnet name"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-4"
  description = "type for default compute instances"
}

variable "min_instances" {
  type        = number
  default     = 2
  description = "Max compute instances in the cluster"
}

variable "max_instances" {
  type        = number
  default     = 3
  description = "Max compute instances in the cluster"
}

variable "cpu_target" {
  type        = number
  default     = 0.75
  description = "CPU target for autoscaling"
}

variable "compute_instance_metadata" {
  type        = map(string)
  default     = {}
  description = "Key/value pairs that are made available within each VM instance."
}

variable "block_project_ssh_keys" {
  type        = bool
  default     = false
  description = "Ability for customers to block or allow the use of project-wide ssh keys in their VM."
}

variable "create_public_management_ip" {
  type        = bool
  default     = false
  description = "Allow the creation of a public IP address for the management interface of each VM. IP will be ephemeral instead of static."
}
