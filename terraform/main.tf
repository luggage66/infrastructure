module "monitoring" {
  source             = "./environments/monitoring"

  billing_account    = var.billing_account
  org_id             = var.org_id
  base_hostname      = var.root_dns_hostname
  region             = var.region
}

output "monitoring_project" {
  value = module.monitoring.project_id
}

output "monitoring_zone" {
  value = module.monitoring.managed_zone_name
}

output "monitoring_dns_servers" {
  value = module.monitoring.name_servers
}

output "static_ip" {
  value = module.monitoring.static_ip
}
