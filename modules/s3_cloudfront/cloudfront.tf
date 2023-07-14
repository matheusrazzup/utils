locals {
  s3_origin_id = var.bucket_name
}

resource "aws_cloudfront_origin_access_control" "unified" {
  name                              = var.bucket_name
  description                       = "${var.bucket_name} OAI"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name              = aws_s3_bucket.unified.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.unified.id
    origin_id                = local.s3_origin_id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = var.bucket_name

  aliases = var.domains

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    cache_policy_id = aws_cloudfront_cache_policy.version.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  web_acl_id = var.webacl_arn

}

resource "aws_cloudfront_cache_policy" "version" {
  name        = "version-policy"
  comment     = "version-policy"
  default_ttl = 1
  max_ttl     = 100
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["ver"]
      }
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}