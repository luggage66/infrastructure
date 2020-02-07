variable "k8s_project" {
  type = string
}

variable "location" {
  type = string
}

variable "k8s_cluster_name" {
  type = string
}

variable "namespace" {
  default = "jupyterhub"
}

variable "subdomain" {
  type    = string
  default = "jupyter"
}

variable "path" {
  type    = string
  default = ""
}

variable "issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "ClusterIssuer name"
}

variable "base_hostname" {
  type = string
}

variable "certificate_secret_name" {
  type    = string
  default = "jupyter-certificate-secret"
}

variable "certificate_name" {
  type    = string
  default = "jupyter"
}

variable fake_depends_on {
  default = []
  type    = list(object({}))
}
