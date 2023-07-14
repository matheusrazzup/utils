resource "helm_release" "metrics-server" {
  name             = "{{name}}"
  repository       = "https://kubernetes-sigs.github.io/metrics-server"
  chart            = "metrics-server"
  version          = "0.6.3"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = "600"
  values = [<<EOF
    commonLabels:
      app: metrics-server
    topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      nodeAffinityPolicy: Ignore
      labelSelector:
        matchLabels:
          app: metrics-server
  EOF
  ]
}