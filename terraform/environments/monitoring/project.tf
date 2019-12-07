variable "billing_account" {}
variable "org_id" {}

variable "region" {}

variable "project_services" {
  default = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com"
  ]
}

provider "google" {
  region = var.region
}

resource "random_id" "monitoring_project_name" {
  byte_length = 4
  prefix      = "monitoring-"
}

resource "google_project" "monitoring" {
  name            = "monitoring"
  project_id      = random_id.monitoring_project_name.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "project_services" {
  project = google_project.monitoring.project_id

  count              = length(var.project_services)
  service            = element(var.project_services, count.index)
  disable_on_destroy = "false"
}

output "project_id" {
  value = "${google_project.monitoring.project_id}"
}
