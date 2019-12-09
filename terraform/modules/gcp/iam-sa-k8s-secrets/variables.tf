variable "project" {
  type        = string
  description = "Google Cloud project ID to add the service account to"
}

variable "service_account_id" {
  type        = string
  description = "The service account id to create. If only creating a single service account, use this variable."
  default     = ""
}

variable "service_account_ids" {
  type        = list(string)
  description = "The ids (username) of the service accounts to create"
  default = [
  ]
}

variable "service_account_name" {
  type        = string
  description = "The display name of the service account to create. If 'service_account_ids' are specified and 'service_account_names' are not specified, this will be used as the name for all service accounts."
  default     = ""
}

variable "service_account_names" {
  type        = list(string)
  description = "The display name of the service accounts to create. Defaults to 'service_account_ids'. If specified length must match 'service_account_ids'"
  default = [
  ]
}

variable "secret_namespace" {
  type        = string
  description = "The k8s namespace to create the secret in. Defaults to 'default'"
  default     = ""
}

variable "secret_namespaces" {
  type        = list(string)
  description = "The Kubernetes namespaces to save the secrets containing the service account JSON key file. Either 'secret_namespace' and 'secret_names', 'secret_names' and 'secret_namespace', or 'secret_namespaces' and 'secret_name' must be specified if 'service_account_ids' is specified. If specified, length must match 'service_account_ids'"
  default = [
  ]
}

variable "secret_annotations" {
  type        = map(string)
  description = "Kubernetes annotations added to the secrets of all service account"
  default     = {}
}

variable "secret_labels" {
  type        = map(string)
  description = "Kubernetes labels added to the secrets of all service account"
  default     = {}
}

variable "secret_name" {
  type        = string
  description = "The k8s metadata.name for the secret with the service account JSON key files."
  default     = ""
}

variable "secret_names" {
  type        = list(string)
  description = "The k8s metadata.name for the secrets with the service account JSON key file. Either 'secret_namespace' and 'secret_names', 'secret_names' and 'secret_namespace', or 'secret_namespaces' and 'secret_name' must be specified if 'service_account_ids' is specified. If specified, length must match 'service_account_ids'"
  default = [
  ]
}

variable "secret_key" {
  type        = string
  description = "The 'key' in the data of the k8s secret created."
  default     = ""
}

variable "secret_keys" {
  type        = list(string)
  description = "The keys inside the kubernetes 'data' to set the JSON key value to"
  default = [
  ]
}

variable "roles" {
  type        = list(string)
  description = "The list of roles to be granted to the GCP service account"
}

variable "role_project" {
  type        = string
  description = "The project the iam policy will be added for the given roles. Defaults to the 'project'"
  default     = ""
}

