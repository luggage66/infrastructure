variable "billing_account" {}
variable "org_id" {}
variable "region" {}

variable "subdomain" {
  type = string
  default = "monitoring"
}

variable "base_hostname" {
  type        = string
}

variable "tiller_version" {
  type    = string
  default = "2.16.1"
}
