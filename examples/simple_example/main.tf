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

resource "random_string" "prefix" {
  length  = 4
  upper   = false
  special = false
}

module "out_of_band_security" {
  source = "../.."

  project_id    = var.project_id
  naming_prefix = "test-prefix-${random_string.prefix.result}"
  source_image  = "https://www.googleapis.com/compute/v1/projects/cisco-public/global/images/cisco-ftdv-7-1-0-92"
}
