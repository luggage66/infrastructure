resource "google_container_cluster" "cluster" {
  name     = var.k8s_cluster_name
  location = var.location
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
  location   = var.location
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  management {
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "n1-standard-2"
    

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = [ local.cluster_network_tag ]

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

resource "google_container_node_pool" "minecraft" {
  name       = "minecraft"
  project    = var.k8s_project
  location   = var.location
  cluster    = google_container_cluster.cluster.name
  node_count = 2

  management {
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "n1-standard-2"
    

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = [ local.cluster_network_tag ]

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    taint = [
      {
        key = "role"
        value = "minecraft"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}
