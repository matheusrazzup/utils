resource "aws_security_group" "efs_security_group" {
  name        = "efs-security-group"
  description = "Allow EFS Inbound traffic into vpc"
  vpc_id      = data.aws_vpc.eksvpc.id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_vpc.eksvpc.cidr_block_associations[0].cidr_block,
      data.aws_vpc.eksvpc.cidr_block_associations[1].cidr_block
    ]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}