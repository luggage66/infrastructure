data "google_client_config" "current" {
}

resource "kubernetes_secret" "accounts" {
  count = length(var.service_account_ids)

  metadata {
    name      = length(var.secret_names) > count.index ? var.secret_names[count.index] : var.secret_name
    namespace = length(var.secret_namespaces) > count.index ? var.secret_namespaces[count.index] : var.secret_namespace != "" ? var.secret_namespace : "default"

    annotations = var.secret_annotations

    labels = var.secret_labels
  }

  data = zipmap(
    [
      length(var.secret_keys) > count.index ? var.secret_keys[count.index] : var.secret_key != "" ? var.secret_key : "application_default_credentials.json",
    ],
    [
      base64decode(
        google_service_account_key.accounts[count.index].private_key,
      ),
    ],
  )
}

resource "kubernetes_secret" "account" {
  count = var.service_account_id != "" ? 1 : 0

  metadata {
    name      = var.secret_name
    namespace = var.secret_namespace

    annotations = var.secret_annotations

    labels = var.secret_labels
  }
  data = zipmap(
    [
      var.secret_key != "" ? var.secret_key : "application_default_credentials.json",
    ],
    [
      base64decode(
        google_service_account_key.account[0].private_key
      ),
    ],
  )
}

