provider "google" {}
# provider "google_beta" {}
provider "helm" {
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v${var.tiller_version}"
}
provider "kubernetes" {}