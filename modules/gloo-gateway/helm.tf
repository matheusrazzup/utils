data "template_file" "gloo-gateway" {
  template = file("${path.module}/templates/gloo-values.tpl")
  vars = {
    account_id = var.account_id
    aws_region = var.aws_region
  }

}

resource "helm_release" "gloo-gateway" {
  name       = "gloo"
  repository = "https://storage.googleapis.com/solo-public-helm"
  chart      = "gloo"
  namespace  = "gloo-system"
  values     = [data.template_file.gloo-gateway.rendered]
}
