
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.ingress_namespace_name
  }

  depends_on = [module.cluster]
}

# helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true
resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  chart      = "nginx-ingress"
  repository = "stable"
  namespace  = var.ingress_namespace_name
  version    = "1.25.2"

  set {
    name  = "rbac.create"
    value = true
  }
  set {
    name  = "controller.publishService.enabled"
    value = true
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.ingress.address
  }
  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "cert-manager/istio-ingressgateway-certs"
  }

  depends_on = [kubernetes_namespace.nginx]
}
