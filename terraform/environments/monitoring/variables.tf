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