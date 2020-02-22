resource "google_compute_firewall" "minecraft" {
  project = module.prod_project.project_id
  name = "minecraft"
  // network = module.prod_project.shared_vpc_name
  network = "default"

  allow { 
    protocol = "tcp"
    ports = [ "25565", "25575" ]
  }

  target_tags = [ module.cluster.node_pool_network_tag ]

  source_ranges = [ "${google_compute_address.ingress.address}/32"]
}