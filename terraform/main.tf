module "prod" {
  source = "./environments/prod"

  billing_account = var.billing_account
  org_id          = var.org_id
  base_hostname   = var.root_dns_hostname
  region          = var.region
  location        = var.location
  admin_email     = var.admin_email

  oauth_client_id     = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret

  providers = {
    google      = google
    google-beta = google-beta
  }
}

output "prod_project_id" {
  value = module.prod.project_id
}

output "prod_dns_servers" {
  value = module.prod.name_servers
}

output "static_ip" {
  value = module.prod.static_ip
}
