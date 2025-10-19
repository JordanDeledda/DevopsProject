############################
# Namespaces
############################
resource "kubernetes_namespace" "ingress" {
  metadata { name = "ingress-nginx" }
}

resource "kubernetes_namespace" "metallb" {
  metadata { name = "metallb-system" }
}

resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

resource "kubernetes_namespace" "kube_dash" {
  metadata { name = "kubernetes-dashboard" }
}

resource "kubernetes_namespace" "loki" {
  metadata { name = "loki" }
}

############################
# Ingress NGINX
############################
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = kubernetes_namespace.ingress.metadata[0].name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.0"
  values           = [file("${path.module}/values/ingress-nginx.values.yml")]
  create_namespace = false
  timeout          = 600
}

############################
# MetalLB (chart + config)
############################
resource "helm_release" "metallb" {
  name             = "metallb"
  namespace        = kubernetes_namespace.metallb.metadata[0].name
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = "0.14.5"
  create_namespace = false
  wait             = true
  timeout          = 600

  values = [
    templatefile("${path.module}/values/metallb.values.tmpl.yml", {
      metallb_address_pool = var.metallb_address_pool
    })
  ]
}

############################
# kube-prometheus-stack
############################
resource "helm_release" "kube_prometheus" {
  name             = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "61.7.0"
  create_namespace = false
  values = [templatefile("${path.module}/values/kube-prometheus.values.yml", {
    grafana_admin_password = var.grafana_admin_password
  })]
  timeout    = 1200
  depends_on = [helm_release.ingress_nginx, helm_release.metallb]
}

############################
# Kubernetes Dashboard
############################
resource "helm_release" "dashboard" {
  name             = "kubernetes-dashboard"
  namespace        = kubernetes_namespace.kube_dash.metadata[0].name
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  version          = "7.5.0"
  create_namespace = false
  values           = [file("${path.module}/values/dashboard.values.yml")]
  timeout          = 600
  depends_on       = [helm_release.ingress_nginx]
}

############################
# Loki stack
############################
resource "helm_release" "loki_stack" {
  name             = "loki-stack"
  namespace        = kubernetes_namespace.loki.metadata[0].name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  version          = "2.10.2"
  create_namespace = false
  values           = [file("${path.module}/values/loki.values.yml")]
  timeout          = 900
  depends_on       = [helm_release.ingress_nginx]
}
