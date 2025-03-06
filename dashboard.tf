resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"

  depends_on = [kubernetes_namespace.example]
  namespace  = kubernetes_namespace.example.metadata[0].name

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "enableInsecureLogin"
    value = "true"
  }
  set {
    name  = "rbac.clusterReadOnlyRole"
    value = "true"
  }
  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }

  # Wait for the deployment to be ready
  wait = true
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  # Wait for the Kubernetes Dashboard and Kubernetes namespace to be created
  depends_on = [helm_release.kubernetes_dashboard, kubernetes_namespace.example]
  namespace  = kubernetes_namespace.example.metadata[0].name

  # Recent updates to the Metrics Server do not work with self-signed certificates by default.
  # Since Docker For Desktop uses such certificates, you’ll need to allow insecure TLS
  set {
    name  = "apiService.create"
    value = "true"
  }
  set {
    name  = "args"
    value = "{--kubelet-insecure-tls=true}"
  }

  # Wait for the release to be deployed
  wait = true
}

# Output metadata of the Kubernetes Dashboard release
output "kubernetes_dashboard_service_metadata" {
  value = helm_release.kubernetes_dashboard.metadata
}

# Output metadata of the Metrics Server release
output "metrics_server_service_metadata" {
  value = helm_release.metrics_server.metadata
}
