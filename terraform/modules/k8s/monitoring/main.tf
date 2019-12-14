resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

data "template_file" "prometheus-operator-values" {
  template = file("${path.module}/prometheus-operator-values.yaml")
  vars = {
    storage_size_gb = var.storage_size_gb
    retention_size_gb = var.retention_size_gb > 0 ? var.retention_size_gb : var.storage_size_gb - 1
    storage_class = var.storage_class
    retention = var.retention
    grafana_ingress_ip_address_name = var.grafana_ingress_ip_address_name
    create_crds = var.create_crds
    alertmanager_enabled = var.alertmanager_enabled

    grafana_ingress_enabled = var.grafana_ingress_enabled
    grafana_host = local.grafana_host
    grafana_certificate_secret_name = var.grafana_certificate_secret_name
    grafana_root_url = "${local.grafana_root_url}/"
    grafana_path = local.grafana_path
    grafana_log_level = local.grafana_log_level

    grafana_oauth_enabled = var.auth0_enabled
    grafana_oauth_name = local.grafana_oauth.name
    grafana_oauth_client_id = local.grafana_oauth.client_id
    grafana_oauth_client_secret = local.grafana_oauth.client_secret
    grafana_oauth_scopes = local.grafana_oauth.scopes
    grafana_oauth_auth_url = local.grafana_oauth.auth_url
    grafana_oauth_token_url = local.grafana_oauth.token_url
    grafana_oauth_logout_url = local.grafana_oauth.logout_url
    grafana_oauth_role_attribute_path = "" # local.grafana_oauth.role_attribute_path
  }
}

resource "helm_release" "prometheus-operator" {
  chart = "prometheus-operator"
  repository = "stable"
  name = var.helm_release_name
  namespace = var.namespace
  version = var.helm_chart_version

  values = concat([data.template_file.prometheus-operator-values.rendered],var.helm_values)

  depends_on = [kubernetes_namespace.monitoring]
}

data "template_file" "prometheus-operator-certificate" {
  template = file("${path.module}/grafana-certificate.yaml")

  vars = {
    issuer_name                     = var.issuer_name
    grafana_certificate_secret_name = var.grafana_certificate_secret_name
    grafana_host = local.grafana_host
    namespace = var.namespace
    grafana_certificate_name = var.grafana_certificate_name
  }
}

resource "null_resource" "prometheus-operator-certificate" {
  triggers = {
    manifest_sha1 = sha1(data.template_file.prometheus-operator-certificate.rendered)
  }

  provisioner "local-exec" {
    command = <<EOF
echo '${data.template_file.prometheus-operator-certificate.rendered}' | kubectl apply --context gke_${var.k8s_project}_${var.location}_${var.k8s_cluster_name} -f -
EOF

  }
}