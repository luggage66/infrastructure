module "prod_project" {
  source = "../../modules/gcp/project"

  project_name    = "prod"
  billing_account = var.billing_account
  org_id          = var.org_id

  project_services = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com"
  ]

  providers = {
    google = google
  }
}

module "dns-zone" {
  source = "../../modules/gcp/dns-zone"

  project_name      = module.prod_project.project_id
  dns_root_hostname = var.base_hostname
}

resource "google_compute_address" "ingress" {
  name         = "cluster-ingress"
  project      = module.prod_project.project_id
  region       = var.region
  address_type = "EXTERNAL"
}

resource "google_dns_record_set" "ingress" {
  managed_zone = module.dns-zone.managed_zone_name
  project      = module.prod_project.project_id
  name         = "${var.base_hostname}."
  ttl          = 300
  type         = "A"

  rrdatas = [
    google_compute_address.ingress.address
  ]
}

resource "google_dns_record_set" "ingress-wildcard" {
  managed_zone = module.dns-zone.managed_zone_name
  project      = module.prod_project.project_id
  name         = "*.${var.base_hostname}."
  ttl          = 300
  type         = "CNAME"

  rrdatas = [
    "${var.base_hostname}."
  ]
}

module "cluster" {
  source = "../../modules/gcp/simple-cluster"

  k8s_project      = module.prod_project.project_id
  location         = "us-east4-a"
  k8s_cluster_name = "my-cluster"
  admin_email      = var.admin_email
}

module "cert-manager" {
  source = "../../modules/k8s/cert-manager"

  project          = module.prod_project.project_id
  location         = var.location
  k8s_cluster_name = module.cluster.k8s_cluster_name

  dns_project               = module.prod_project.project_id
  issuer_admin_email        = var.admin_email
  certificate_base_hostname = var.base_hostname

  providers = {
    google      = google
    google-beta = google-beta
    kubernetes  = kubernetes
    helm        = helm
  }
}

module "monitoring" {
  source = "../../modules/k8s/monitoring"

  k8s_project      = module.prod_project.project_id
  k8s_cluster_name = "my-cluster"
  location         = var.location
  base_hostname = var.base_hostname

  oauth_client_id     = var.oauth_client_id
  oauth_client_secret = var.oauth_client_secret
  grafana_ingress_ip_address_name    = google_compute_address.ingress.name

  fake_depends_on = [
    module.cluster
  ]
}
