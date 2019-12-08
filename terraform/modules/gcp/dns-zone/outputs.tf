output "managed_zone_name" {
  value = google_dns_managed_zone.root-dns.name
}

output "name_servers" {
  value = google_dns_managed_zone.root-dns.name_servers
}