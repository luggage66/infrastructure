variable "billing_account" {}
variable "org_id" {}

variable "region" {}

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

# resource "google_project_services" "monitoring" {
#   project = google_project.monitoring.project_id

#   services = [
#   ]
# }

output "project_id" {
  value = "${google_project.monitoring.project_id}"
}
