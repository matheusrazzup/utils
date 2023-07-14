resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.6.0"
  namespace  = "kube-system"

  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "controller.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  depends_on = [
    helm_release.metrics-server
  ]
}
resource "helm_release" "metrics-server" {
  name  = "metrics-server"
  chart = "${path.module}/metrics-server"

}
resource "helm_release" "calico" {
  name       = "calico"
  chart      = "tigera-operator"
  repository = "https://docs.projectcalico.org/charts"
  version    = "v3.21.4"
  namespace  = "kube-system"

}

resource "helm_release" "external-secrets-operator" {
  name       = "stackspot-aws-eso"
  namespace  = "kube-system"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.7.2"
}


resource "kubectl_manifest" "karpenter_service_account" {
  yaml_body = <<YAML
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::${var.account_id}:role/KarpenterNodeRole-${var.cluster_name}
    name: karpenter
    namespace: kube-system
  YAML

  depends_on = [
    module.karpenter_assumable_role
  ]
}
resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: ${var.provisionerName}
  spec:
    limits:
      resources:
        cpu: 1000
    provider:
      instanceProfile: ${var.instanceProfileName}
      subnetSelector:
        Name: ${var.subnetSelector}
      securityGroupSelector:
        "aws:eks:cluster-name": ${var.cluster_name}
      tags:
        provisioned-by-karpenter: "true"
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "helm_release" "k8s-ingress-nginx" {
  name             = "k8s-ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.2.5"
  namespace        = "kube-system"
  create_namespace = true
  timeout          = "600"
  values = [<<EOF
    controller:
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
      config:
        enable-underscores-in-headers: 'true'
  EOF
  ]
}

resource "kubectl_manifest" "ssm_installer" {
  yaml_body = <<YAML
  apiVersion: apps/v1
  kind: DaemonSet
  metadata:
    labels:
      k8s-app: ssm-installer
    name: ssm-installer
    namespace: kube-system
  spec:
    selector:
      matchLabels:
        k8s-app: ssm-installer
    template:
      metadata:
        labels:
          k8s-app: ssm-installer
      spec:
        containers:
        - name: sleeper
          image: public.ecr.aws/runecast/busybox:latest
          command: ['sh', '-c', 'echo I keep things running! && sleep 3600']
        initContainers:
        - image: public.ecr.aws/amazonlinux/amazonlinux:latest
          imagePullPolicy: Always
          name: ssm
          command: ["/bin/bash"]
          args: ["-c","echo '* * * * * root yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm & rm -rf /etc/cron.d/ssmstart' > /etc/cron.d/ssmstart"]
          securityContext:
            allowPrivilegeEscalation: true
          volumeMounts:
          - mountPath: /etc/cron.d
            name: cronfile
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
        volumes:
        - name: cronfile
          hostPath:
            path: /etc/cron.d
            type: Directory
        dnsPolicy: ClusterFirst
        restartPolicy: Always
        schedulerName: default-scheduler
        terminationGracePeriodSeconds: 30
  YAML
}