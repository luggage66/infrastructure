locals {
  host       = "${var.subdomain}.${var.base_hostname}"
  path       = var.path
  identifier = "https://${local.host}"
  root_url   = "${local.identifier}${local.path}"
}
