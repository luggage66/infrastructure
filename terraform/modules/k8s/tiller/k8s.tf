resource "kubernetes_cluster_role_binding" "user-cluster-admin" {
  metadata {
    name = "tf-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind = "User"
    name = var.admin_email
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = [kubernetes_cluster_role_binding.user-cluster-admin]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = [kubernetes_service_account.tiller]
}

resource "null_resource" "wait-for-it" {
  triggers = {
    tiller = "tiller"
  }
  depends_on = [kubernetes_cluster_role_binding.tiller]
}

