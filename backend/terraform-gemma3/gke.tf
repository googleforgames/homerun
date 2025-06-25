# # Copyright 2023 Google LLC All Rights Reserved.
# #
# # Licensed under the Apache License, Version 2.0 (the "License");
# # you may not use this file except in compliance with the License.
# # You may obtain a copy of the License at
# #
# #     http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS,
# # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# # See the License for the specific language governing permissions and
# # limitations under the License.

# # google_client_config and kubernetes provider must be explicitly specified like the following.
# data "google_client_config" "default" {}

# # GKE cluster
# resource "google_container_cluster" "autopilot2" {
#   name     = "smartnpc"
#   location = "us-central1"

#   network    = module.vpc.network_name
#   subnetwork = "sn-usc1"

#   # Enabling Autopilot for this cluster
#   enable_autopilot   = true
#   initial_node_count = 1
#   cluster_autoscaling {
#     auto_provisioning_defaults {
#       service_account = google_service_account.sa_gke_cluster.email
#     }
#   }
#   deletion_protection = false
#   depends_on = [
#     google_service_account.sa_gke_cluster,
#     module.vpc
#   ]
# }
