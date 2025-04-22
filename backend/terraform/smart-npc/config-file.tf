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


resource "random_string" "random" {
  length           = 36
  special          = true
  override_special = "!@#$%^&*"
}

locals {
  config_content = <<-EOT
        ["gcp"]
        database_private_ip_address="${google_sql_database_instance.postgresql.private_ip_address}"
        database_public_ip_address="${google_sql_database_instance.postgresql.public_ip_address}"
        postgres_instance_connection_name="${var.google_project_id}:${var.google_default_region}:${google_sql_database_instance.postgresql.name}"
        database_user_name="${google_sql_user.llmuser.name}"
        database_password_key="pgvector-password"
        image_upload_gcs_bucket="${module.gcs.names_list[0]}"
        google-project-id="${var.google_project_id}"
        cache-server-host = "${google_redis_instance.cache.host}"
        cache-server-port = 6379
        use-cache-server = "True"
        google-default-region = "${var.google_default_region}"
        api-key = "${random_string.random.result}"
  EOT
}

resource "local_file" "config-gcp" {
  filename = "../smartnpc/config.gcp.toml.template"
  content  = local.config_content
}

resource "local_file" "data-config-gcp" {
  filename = "../smartnpc/data/setup/config.toml"
  content  = local.config_content
}


resource "local_file" "generate_config_toml" {
  filename = "../smartnpc/config.toml"
  content  = join(" ", [file("../smartnpc/config.gcp.toml.template"), file("../smartnpc/config.app.toml.template")])
  depends_on = [
    local_file.config-gcp
  ]
}
