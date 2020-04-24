output "k8s_cluster_name" {
  value      = google_container_cluster.cluster.name
}

output "node_pool_network_tag" {
  value = local.cluster_network_tag
}