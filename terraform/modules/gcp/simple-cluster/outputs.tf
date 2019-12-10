output "k8s_cluster_name" {
  depends_on = [module.tiller.service_account_name]
  value      = google_container_cluster.cluster.name
}
