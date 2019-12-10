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