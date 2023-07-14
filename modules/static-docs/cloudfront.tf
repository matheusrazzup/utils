locals {
  s3_origin_id = var.bucket_name
}

data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_control" "docs" {
  name                              = var.bucket_name
  description                       = "${var.bucket_name} OAI"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name              = aws_s3_bucket.docs.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.docs.id
    origin_id                = local.s3_origin_id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = var.bucket_name

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  aliases = var.domains

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.cache_optimized.id
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    # forwarded_values {
    #   query_string = false

    #   cookies {
    #     forward = "none"
    #   }
    # }

    viewer_protocol_policy = "redirect-to-https"
    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.docs.arn
    }

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

  tags = var.custom_web_acl == true ? { CloudTeam = "Approved" } : {}

  web_acl_id = var.webacl_arn

}

resource "aws_cloudfront_function" "docs" {
  name    = "${var.bucket_name}-rewrite-uri"
  runtime = "cloudfront-js-1.0"
  comment = "Functio to Append /index.html at the end of every endpoint no the distribution"
  publish = true
  code    = file("${path.module}/function-code/function.js")
}
