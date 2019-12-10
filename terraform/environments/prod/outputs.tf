output "managed_zone_name" {
  value = module.dns-zone.managed_zone_name
}

output "name_servers" {
  value = module.dns-zone.name_servers
}

output "static_ip" {
  value = google_compute_address.ingress.address
}

output "project_id" {
  value = module.prod_project.project_id
}
