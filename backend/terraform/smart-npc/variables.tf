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

variable "google_default_region" {
  type        = string
  description = "The default Google Cloud region."
  default     = "us-central1"
}

variable "google_default_zone" {
  type        = string
  description = "The default Google Cloud zone."
  default     = "us-central1-b"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "subnet_name" {
  type        = string
  default     = "sn-usc1"
  description = "Subnet name"
}

variable "google_project_id" {
  type        = string
  description = "Google Cloud project ID."
}

variable "vpcconnector_cidr" {
  type        = string
  description = "Internal IP address range of the VPC connector"
  default     = "10.8.200.0/28"
}
