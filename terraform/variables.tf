variable "billing_account" {}
variable "org_id" {}
variable "region" {
  default = "us-east4"
}
variable "root_dns_hostname" {
  type = string
}

variable "admin_email" {
  type = string
}

variable "google_credentials_path" {
  description = "Path to a google service accounts credentials jsons file"
  type = string
}