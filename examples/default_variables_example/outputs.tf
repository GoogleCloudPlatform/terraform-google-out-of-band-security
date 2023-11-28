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
  description = "name of managed instance group created"
  value       = module.out_of_band_security.mig
}

output "forwarding_rule" {
  description = "name of the forwarding rule created for traffic"
  value       = module.out_of_band_security.forwarding_rule
}

output "instance_template" {
  description = "name of the instance template"
  value       = module.out_of_band_security.instance_template
}

output "health_check" {
  description = "name of the health check for the LB backend service"
  value       = module.out_of_band_security.health_check
}
