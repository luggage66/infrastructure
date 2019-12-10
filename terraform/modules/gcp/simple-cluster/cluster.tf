resource "google_container_cluster" "cluster" {
  name     = var.k8s_cluster_name
  location = var.region
  project = var.k8s_project

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "my-node-pool"
  project    = var.k8s_project
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

module "tiller" {
  source = "../../k8s/tiller"
  admin_email = var.admin_email
}