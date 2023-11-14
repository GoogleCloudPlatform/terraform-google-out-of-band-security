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
  description = "Project the resources will be deployed into."
}

variable "naming_prefix" {
  type        = string
  description = "A prefix string to be appended in front of all deployed resources so they can be easily traced back."
}

variable "source_image" {
  type        = string
  description = "Source image url path for the security appliance being deployed."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The GCP Region for deployment."
}

variable "zones" {
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
  description = "List of GCP Zones for deployment."
}

variable "traffic_subnet_cidr" {
  type        = string
  default     = "10.127.10.0/24"
  description = "CIDR range of the subnet where the firewall VMs are inspecting traffic. This VPC will need to be peered to existing VPC's for packet-mirroring, so ensure it is a unique range for your organization."
}

variable "mgmt_network" {
  type = string

  default     = "default"
  description = "The name of an existing VPC that will be used for the management interface of the deployed firewall VMs."
}

variable "mgmt_subnet" {
  type        = string
  default     = "default"
  description = "The name of an existing subnet within this VPC (and available for every chosen zone) that will be used for the management interface of the deployed firewall VMs."
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-4"
  description = "The machine type for the firewall compute instances."
}

variable "min_instances" {
  type        = number
  default     = 2
  description = "Minimum compute instances in the cluster."
}

variable "max_instances" {
  type        = number
  default     = 3
  description = "Maximum compute instances in the cluster."
}

variable "cpu_target" {
  type        = number
  default     = 0.75
  description = "CPU target for autoscaling."
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

variable "scopes" {
  type        = list(string)
  default     = []
  description = "The list of access scopes for the service account attached to the VM."
}

variable "additional_disks" {
  type = map(object({
    disk_size = number
    disk_type = string
  }))
  default     = {}
  description = "Allow the creation of one or more persistent disks for each instance."
}

