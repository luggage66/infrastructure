

module "monitoring" {
  source             = "./environments/monitoring"

  billing_account    = var.billing_account
  org_id             = var.org_id
}

output "monitoring_project" {
  value = module.monitoring.project_id
}