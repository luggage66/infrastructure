resource "google_compute_firewall" "minecraft" {
  project = module.prod_project.project_id
  name    = "minecraft"
  // network = module.prod_project.shared_vpc_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["25565", "25575", "25566", "25576"]
  }

  target_tags = [module.cluster.node_pool_network_tag]

  source_ranges = ["${google_compute_address.ingress.address}/32"]
}

resource "google_compute_resource_policy" "minecraft-data" {
  name = "minecraft-data"

  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "12:00"
      }
    }
    retention_policy {
      max_retention_days    = 14
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      labels = {
        backup-of = "minecraft-data"
      }
      storage_locations = [var.region]
      guest_flush       = false
    }
  }
}
