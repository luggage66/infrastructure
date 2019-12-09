resource "google_project_iam_member" "cert-manager-dns-admin" {
  member  = "serviceAccount:${module.cert-manager-sa.email}"
  project = var.dns_project
  role    = "roles/dns.admin"
}

