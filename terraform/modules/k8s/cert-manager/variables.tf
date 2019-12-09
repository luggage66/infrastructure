variable "region" {
  type        = string
  default     = "us-central1"
  description = "The default region for Google cloud services"
}

variable "project" {
  type        = string
  description = "Google Cloud project ID to add the service account to"
}

variable "k8s_cluster_name" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "0.12.0"
}

variable "app_version" {
  type    = string
  default = "0.12.0"
}

variable "chart_repo" {
  type    = string
  default = "jetstack"
}

variable "chart_repo_url" {
  type    = string
  default = "https://charts.jetstack.io"
}

variable "release_name" {
  type        = string
  default     = "cert-manager"
  description = "The Helm release name of the cert-manager deployment"
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "The Kubernetes namespace to install cert-manager"
}

variable "dns_project" {
  type        = string
  description = "The Google Cloud project that hosts the DNS that will be used to validate certs"
}

variable "issuer_admin_email" {
  type        = string
  description = "The email to give to LetsEncrypt for certificate issuance"
}

variable "certificate_base_hostname" {
  type        = string
  description = "The hostname used for the istio ingress certificate of the cluster"
}

variable "certificate_namespace" {
  type    = string
  default = "cert-manager"
}

variable "certificate_name" {
  type    = string
  default = "istio-ingressgateway-certs"
}

variable "certificate_secret_name" {
  type    = string
  default = "istio-ingressgateway-certs"
}

variable "issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "ClusterIssuer name"
}

variable "acme_secret_name" {
  type        = string
  description = "LetsEncrypt ClusterIssuer secret"
  default     = "acme-cluster-issuer"
}

