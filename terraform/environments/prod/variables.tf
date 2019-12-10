variable "billing_account" {}
variable "org_id" {}
variable "region" {}

variable "base_hostname" {
  type        = string
}

variable "tiller_version" {
  type    = string
  default = "2.16.1"
}

variable "admin_email" {
  type = string
}

variable "ingress_namespace_name" {
  default = "nginx-ingress"
}