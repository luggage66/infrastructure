resource "google_dns_managed_zone" "root-dns" {
  name     = replace(var.dns_root_hostname, ".", "-")
  project  = var.project_name
  dns_name = "${var.dns_root_hostname}."
}

resource "google_dns_record_set" "parent-dns-ns" {
  count = var.parent_managed_zone_name != "" ? 1 : 0
  project = var.parent_managed_zone_project
  managed_zone = var.parent_managed_zone_name
  name = google_dns_managed_zone.root-dns.dns_name
  ttl = 300
  type = "NS"
  rrdatas = google_dns_managed_zone.root-dns.name_servers
}