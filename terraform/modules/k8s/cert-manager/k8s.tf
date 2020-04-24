resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = var.namespace
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
}

module "cert-manager-sa" {
  source = "../../gcp/iam-sa-k8s-secrets"

  secret_name      = "cert-manager-iam-sa"
  secret_namespace = kubernetes_namespace.cert-manager.id
  secret_key       = "google_application_credentials.json"

  project              = var.project
  service_account_id   = "cert-manager"
  service_account_name = "Cert-Manager"

  roles = [
    "roles/dns.admin",
  ]

  providers = {
    google      = google
    google-beta = google-beta
    kubernetes  = kubernetes
  }
}

resource "null_resource" "cert-manager-crds" {
  triggers = {
    manifest_sha1 = filesha1("${path.module}/crds.yaml")
  }

  provisioner "local-exec" {
    command = <<EOF
    kubectl apply --context gke_${var.project}_${var.location}_${var.k8s_cluster_name} --validate=false -f ${path.module}/crds.yaml
EOF

  }
}

data "template_file" "cert-manager-clusterissuer" {
  template = file("${path.module}/acme-clusterissuer.yaml")

  vars = {
    namespace        = var.namespace
    secret_key       = module.cert-manager-sa.secret_key
    secret_name      = module.cert-manager-sa.secret_name
    acme_secret_name = var.acme_secret_name
    admin_email      = var.issuer_admin_email
    dns_project      = var.dns_project
    issuer_name      = var.issuer_name
  }
}

resource "null_resource" "cert-manager-clusterissuer" {
  triggers = {
    manifest_sha1 = sha1(data.template_file.cert-manager-clusterissuer.rendered)
  }

  provisioner "local-exec" {
    command = <<EOF
echo '${data.template_file.cert-manager-clusterissuer.rendered}' | kubectl apply --context gke_${var.project}_${var.location}_${var.k8s_cluster_name} -f -
EOF

  }

  depends_on = [
    null_resource.cert-manager-crds,
    kubernetes_namespace.cert-manager,
  ]
}

data "template_file" "cert-manager-certificate" {
  template = file("${path.module}/certificate.yaml")

  vars = {
    issuer_name               = var.issuer_name
    certificate_name          = var.certificate_name
    certificate_base_hostname = var.certificate_base_hostname
    certificate_namespace     = var.certificate_namespace
    certificate_secret_name   = var.certificate_secret_name
  }
}

resource "null_resource" "cert-manager-certificate" {
  triggers = {
    manifest_sha1 = sha1(data.template_file.cert-manager-certificate.rendered)
  }

  provisioner "local-exec" {
    command = <<EOF
echo '${data.template_file.cert-manager-certificate.rendered}' | kubectl apply --context gke_${var.project}_${var.location}_${var.k8s_cluster_name} -f -
EOF

  }

  depends_on = [helm_release.cert-manager]
}

resource "helm_release" "cert-manager" {
  chart     = "cert-manager"
  repository = data.helm_repository.cert-manager.metadata[0].name
  name      = var.release_name
  version   = "v${var.chart_version}"
  namespace = var.namespace

  wait = true

  set {
    name  = "ingressShim.extraArgs"
    value = "{--default-issuer-name=${var.issuer_name},--default-issuer-kind=ClusterIssuer}"
  }

  set {
    name  = "image.tag"
    value = "v${var.app_version}"
  }

  depends_on = [null_resource.cert-manager-clusterissuer]
}

