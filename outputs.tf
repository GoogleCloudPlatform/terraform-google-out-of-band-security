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

output "mig" {
  description = "Name of managed instance group created."
  value       = google_compute_region_instance_group_manager.main.name
}

output "forwarding_rule" {
  description = "Name of the forwarding rule created for traffic."
  value       = google_compute_forwarding_rule.main.name
}

output "instance_template" {
  description = "Name of the instance template."
  value       = google_compute_instance_template.main.name
}

output "health_check" {
  description = "name of the health check for the LB backend service"
  value       = google_compute_health_check.hc.name
}
