variable "ingress_namespace_name" {
  default = "nginx"
}
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.ingress_namespace_name
  }
}

# helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true
resource "helm_release" "nginx" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = var.ingress_namespace_name

  # set {
  #   name = "service.loadBalancerIP"
  #   value = google_compute_address.ingress.address
  # }
  set {
    name = "rbac.create"
    value = true
  }
  set {
    name = "controller.publishService.enabled"
    value = true
  }
  # set {
  #   name = "ingress.hosts[0].host"
  #   value = var.base_hostname
  # }
  # set {
  #   name = "ingress.tls[0].secretName"
  #   value = "istio-ingressgateway-certs"
  # }
  # set {
  #   name = "ingress.tls[0].hosts"
  #   value = "{${var.base_hostname}}"
  # }

  depends_on = [kubernetes_namespace.nginx]
}