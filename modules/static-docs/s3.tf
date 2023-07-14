resource "aws_s3_bucket" "docs" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.bucket_name} static Bucket"
  }
}

resource "aws_s3_bucket_acl" "docs" {
  bucket = aws_s3_bucket.docs.id
  acl    = "private"
}

data "aws_iam_policy_document" "docs" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.docs.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "docs" {
  bucket = aws_s3_bucket.docs.id
  policy = data.aws_iam_policy_document.docs.json
}