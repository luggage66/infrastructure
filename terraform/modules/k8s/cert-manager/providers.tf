provider "google" {
}

provider "google-beta" {
}

provider "kubernetes" {
}

provider "helm" {
}

data "helm_repository" "cert-manager" {
  name = var.chart_repo
  url  = var.chart_repo_url
}

