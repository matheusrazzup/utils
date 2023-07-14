resource "aws_s3_bucket" "loki_chunks" {
  bucket = var.loki_bucket_name

}