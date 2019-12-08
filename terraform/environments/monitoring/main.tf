provider "google" {
}

variable "billing_account" {}
variable "org_id" {}

module "monitoring_project" {
  source = "../../modules/gcp/project"

  project_name = "monitoring"
  region = "us-east4"
  billing_account = var.billing_account
  org_id = var.org_id

  project_services = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com"
  ]
}

module "monitoring_cluster" {
  source = "../../modules/gcp/simple-cluster"

  k8s_project = module.monitoring_project.project_id
  region = "us-east4"
  k8s_cluster_name = "monitoring-cluster"
}

output "project_id" {
  value = module.monitoring_project.project_id
}