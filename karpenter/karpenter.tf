resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "v0.29.0"
  namespace  = "kube-system"
  values = [<<EOF
    settings:
      aws:
        clusterName: "${var.cluster_name}"
    serviceAccount:
      annotations:
        "eks.amazonaws.com/role-arn": "${var.role}"
    additionalLabels:
      app: karpenter
    nodeSelector:
      eks.amazonaws.com/nodegroup: ${var.nodegroup_name}
    topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      nodeAffinityPolicy: Ignore
      labelSelector:
        matchLabels:
          app: karpenter
  EOF
  ]
}
