data "aws_caller_identity" "self" {}

### Subnets automatic lookup ###
data "aws_vpcs" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["{{ vpc_name }}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [sort(data.aws_vpcs.vpc.ids)[0]]
  }

  filter {
    name   = "tag:Name"
    values = ["prv*"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
