# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  cloud_build_content = <<-EOT
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', '${var.google_default_region}-docker.pkg.dev/${var.google_project_id}/repo-genai-smartnpc/smart-npc-api', '.' ]
images:
- '${var.google_default_region}-docker.pkg.dev/${var.google_project_id}/repo-genai-smartnpc/smart-npc-api'
EOT
}

resource "local_file" "cloudbuild-yaml" {
  filename = "../smartnpc/cloudbuild.yaml"
  content  = local.cloud_build_content
}
