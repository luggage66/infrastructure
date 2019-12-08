
module "dns-zone" {
  source = "../../modules/gcp/dns-zone"

  project_name = module.monitoring_project.project_id
  dns_root_hostname = local.monitoring_dns_hostname
}

resource "google_compute_address" "ingress" {
  name         = "monitoring-cluster-ingress"
  project      = module.monitoring_project.project_id
  region       = var.region
  address_type = "EXTERNAL"
}

# resource "google_compute_global_address" "ingress" {
#   name = "monitoring-ingress"
#   project = module.monitoring_project.project_id
# }

resource "google_dns_record_set" "ingress" {
  managed_zone = module.dns-zone.managed_zone_name
  project = module.monitoring_project.project_id
  name = "${local.monitoring_dns_hostname}."
  ttl = 300
  type = "A"

  rrdatas = [
    google_compute_address.ingress.address
  ]

}

output "managed_zone_name" {
  value = module.dns-zone.managed_zone_name
}

output "name_servers" {
  value = module.dns-zone.name_servers
}

module "monitoring_project" {
  source = "../../modules/gcp/project"

  project_name = "monitoring"
  region = var.region
  billing_account = var.billing_account
  org_id = var.org_id

  project_services = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com"
  ]
}

module "monitoring_cluster" {
  source = "../../modules/gcp/simple-cluster"

  k8s_project = module.monitoring_project.project_id
  region = "us-east4"
  k8s_cluster_name = "monitoring-cluster"
}

output "project_id" {
  value = module.monitoring_project.project_id
}