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

// Used to identify the cluster in validate.sh.
output "cluster_name" {
  description = "Convenience output to obtain the GKE Cluster name"
  value       = google_container_cluster.cluster.name
}

// Current GCP project
output "gcp_serviceaccount" {
  description = "The email/name of the GCP service account"
  value       = google_service_account.access_postgres.email
}

// Used when setting up the GKE cluster to talk to Postgres.
output "postgres_instance" {
  description = "The generated name of the Cloud SQL instance"
  value       = google_sql_database_instance.default.name
}

// Full connection string for the Postgres DB>
output "postgres_connection" {
  description = "The connection string dynamically generated for storage inside the Kubernetes configmap"
  value       = format("%s:%s:%s", data.google_client_config.current.project, var.region, google_sql_database_instance.default.name)
}

// Postgres DB username.
output "postgres_user" {
  description = "The Cloud SQL Instance User name"
  value       = google_sql_user.default.name
}

// Postgres DB password.
output "postgres_pass" {
  sensitive   = true
  description = "The Cloud SQL Instance Password (Generated)"
  value       = google_sql_user.default.password
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}

output "get_credentials" {
  description = "Gcloud get-credentials command"
  value       = format("gcloud container clusters get-credentials --project %s --region %s --internal-ip %s", var.project, var.region, var.cluster_name)
}
output "bastion_ssh" {
  description = "Gcloud compute ssh to the bastion host command"
  value       = format("gcloud compute ssh %s --project %s --zone %s -- -L8888:127.0.0.1:8888", google_compute_instance.bastion.name, var.project, google_compute_instance.bastion.zone)
}

output "bastion_kubectl" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces"
}
