module "dns-zone" {
  source = "../../modules/gcp/dns-zone"

  project_name = module.monitoring_project.project_id
  dns_root_hostname = var.base_hostname
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
  name = "${var.base_hostname}."
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

output "static_ip" {
  value = google_compute_address.ingress.address
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

module "cert-manager" {
  source = "../../modules/k8s/cert-manager"

  project          = module.monitoring_project.project_id
  region           = data.template_file.tillerdep.rendered
  k8s_cluster_name = module.monitoring_cluster.k8s_cluster_name

  dns_project               = module.monitoring_project.project_id
  issuer_admin_email        = "donald.mull@gmail.com"
  certificate_base_hostname = var.base_hostname

  providers = {
    google      = google
    # google-beta = google-beta
    kubernetes  = kubernetes
    helm        = helm
  }

  # depends_on = [module.tiller]
}

output "project_id" {
  value = module.monitoring_project.project_id
}





module "tiller" {
  source = "../../modules/k8s/tiller"

  providers = {
    google     = google
    kubernetes = kubernetes
    helm       = helm
  }
}

data "template_file" "tillerdep" {
  template = var.region
  vars = {
    service = module.tiller.service_account_name
  }
}
