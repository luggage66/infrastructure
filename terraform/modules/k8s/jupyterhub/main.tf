locals {
  certificateResource = jsonencode({
    apiVersion = "cert-manager.io/v1alpha2"
    kind = "Certificate"
    metadata = {
      name = var.certificate_name
      namespace = var.namespace
    }
    spec = {
      secretName = var.certificate_secret_name
      issuerRef = {
        name = var.issuer_name
        kind = "ClusterIssuer"
      }
      commonName = local.host
      dnsNames = [
        local.host
      ]
    }
  })
}

resource "null_resource" "certificate" {
  triggers = {
    manifest_sha1 = sha1(local.certificateResource)
  }

  provisioner "local-exec" {
    command = <<EOF
echo '${local.certificateResource}' | kubectl apply --context gke_${var.k8s_project}_${var.location}_${var.k8s_cluster_name} -f -
EOF

  }
}