data "template_file" "oss_values" {
  template = file("${path.module}/templates/oss-values.tpl")
  vars = {
    index_prefix = "stkspt-eks-loki-index-"
    loki_bucket  = aws_s3_bucket.loki_chunks.id
    aws_region   = var.aws_region
    release_name = "stackspot-promstack"
    pathmodule   = path.module
  }

  depends_on = [
    aws_s3_bucket.loki_chunks
  ]

}

resource "helm_release" "promstack" {
  count      = var.enable_promstack ? 1 : 0
  name       = "stackspot-promstack"
  namespace  = "observability"
  repository = "https://keyval-dev.github.io/charts"
  chart      = "oss-observability"

  values = [data.template_file.oss_values.rendered]

}

resource "helm_release" "odigos" {
  count            = var.enable_odigos ? 1 : 0
  name             = "stackspot-odigos"
  namespace        = "odigos-system"
  create_namespace = true
  repository       = "https://keyval-dev.github.io/odigos-charts/"
  chart            = "odigos"
  version          = "0.2.05"
}

resource "kubectl_manifest" "odigos_configuration" {
  yaml_body = file("${path.module}/templates/odigos-configuration.yaml")

  depends_on = [
    helm_release.odigos
  ]
}