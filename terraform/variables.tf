/*
Copyright 2018 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Required values to be set in terraform.tfvars
variable "project" {
  description = "The project in which to hold the components"
  type        = "string"
}

variable "region" {
  description = "The region in which to create the VPC network"
  type        = "string"
}

variable "zone" {
  description = "The zone in which to create the Kubernetes cluster. Must match the region"
  type        = "string"
}


// Optional values that can be overridden or appended to if desired.
variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
  type        = "string"
  default     = "private-cluster"
}

variable "bastion_tags" {
  description = "A list of tags applied to your bastion instance."
  type        = "list"
  default     = ["bastion"]
}

variable "k8s_namespace" {
  description = "The namespace to use for the deployment and workload identity binding"
  type        = "string"
  default     = "default"
}

variable "k8s_sa_name" {
  description = "The k8s service account name to use for the deployment and workload identity binding"
  type        = "string"
  default     = "postgres"
}

variable "db_username" {
  description = "The name for the DB connection"
  type        = "string"
  default     = "postgres"
}

variable "service_account_iam_roles" {
  type = "list"

  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
  ]
  description = <<-EOF
  List of the default IAM roles to attach to the service account on the
  GKE Nodes.
  EOF
}

variable "service_account_custom_iam_roles" {
  type = "list"
  default = []

  description = <<-EOF
  List of arbitrary additional IAM roles to attach to the service account on
  the GKE nodes.
  EOF
}

variable "project_services" {
  type = "list"

  default = [
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sqladmin.googleapis.com",
    "securetoken.googleapis.com",
  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}
