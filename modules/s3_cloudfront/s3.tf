resource "aws_s3_bucket" "unified" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.bucket_name} static Bucket"
  }
}

resource "aws_s3_bucket_versioning" "unified_versioning" {
  bucket = aws_s3_bucket.unified.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "unified" {
  bucket = aws_s3_bucket.unified.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "unified" {
  bucket = aws_s3_bucket.unified.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

data "aws_iam_policy_document" "unified" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.unified.arn}/*"]

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

  statement {
    actions = ["s3:*"]

    resources = ["${aws_s3_bucket.unified.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.roles_allowed
    }
  }
}

resource "aws_s3_bucket_policy" "unified" {
  bucket = aws_s3_bucket.unified.id
  policy = data.aws_iam_policy_document.unified.json
}