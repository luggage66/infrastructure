
resource "google_container_cluster" "monitoring" {
  name     = "monitoring-cluster"
  location = var.region
  project = google_project.monitoring.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  depends_on = [google_project_service.project_services]
}

resource "google_container_node_pool" "primary_pool" {
  name       = "my-node-pool"
  project    = google_project.monitoring.project_id
  location   = var.region
  cluster    = google_container_cluster.monitoring.name
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