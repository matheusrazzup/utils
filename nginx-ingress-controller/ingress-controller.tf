resource "helm_release" "k8s-ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.7.1"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = "600"
  values = [<<EOF
    controller:
      labels:
        ingress: nginx
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: topology.kubernetes.io/zone
        whenUnsatisfiable: DoNotSchedule
        nodeAffinityPolicy: Ignore
        labelSelector:
          matchLabels:
            ingress: nginx
            app.kubernetes.io/component: controller
      updateStrategy:
        type: RollingUpdate
      kind: Deployment
      service:
        enableHttp: true
        enableHttps: true
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: 'nlb'
          service.beta.kubernetes.io/aws-load-balancer-internal: 'true'
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: 'tcp'
        ports:
          http: 80
          https: 443
        targetPorts:
          http: http
          https: https
      autoscaling:
        enabled: true
        minReplicas: 3
        maxReplicas: 15
      config:
        enable-underscores-in-headers: 'true'
  EOF
  ]
}