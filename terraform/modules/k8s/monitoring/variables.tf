variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "The Kubernetes namespace to install prometheus-operator"
}

variable "region" {
  type = string
}

variable "k8s_cluster_name" {
  type = string
}

variable "helm_values" {
  type        = list(string)
  description = "List of values in raw yaml to pass to helm for the prometheus-operator chart. Values will be merged, in order, as Helm does with multiple -f options"
  default     = []
}

variable "helm_chart_version" {
  type    = string
  default = "8.1.6"
}

variable "k8s_project" {
  type = string
}

variable "create_crds" {
  type    = bool
  default = true
}

variable "helm_release_name" {
  type    = string
  default = "prometheus-operator"
}

variable "storage_class" {
  type    = string
  default = "standard"
}

variable "storage_size_gb" {
  type    = number
  default = 50
}

variable "retention_size_gb" {
  type    = number
  default = 0
}

variable "retention" {
  type    = string
  default = "10d"
}

variable "grafana_certificate_secret_name" {
  type    = string
  default = "grafana-certificate-secret"
}

variable "grafana_certificate_name" {
  type    = string
  default = "grafana"
}

variable "issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "ClusterIssuer name"
}

variable "base_hostname" {
  type = string
}

variable "dns_ttl" {
  type    = number
  default = 3600
}

variable "granafa_subdomain" {
  type    = string
  default = "grafana"
}

variable "grafana_ingress_enabled" {
  type    = bool
  default = true
}

variable "grafana_ingress_ip_address_name" {
  type    = string
  default = "grafana-ingress"
}

variable "grafana_path" {
  type    = string
  default = ""
}

variable "grafana_log_level" {
  type    = string
  default = "info"
}

variable "alertmanager_enabled" {
  type    = bool
  default = true
}

variable "auth0_enabled" {
  type    = bool
  default = true
}

variable "istio_installer_version" {
  type    = string
  default = "1.3.5"
}

variable "oauth_client_id" {
  type = string
}
variable "oauth_client_secret" {
  type = string
}

variable fake_depends_on {
  default = []
  type    = list(object({}))
}

