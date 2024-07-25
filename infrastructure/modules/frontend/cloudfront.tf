resource "aws_cloudfront_distribution" "distribution" {
  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html"

  origin {
    # connection_attempts = 3
    # connection_timeout  = 10
    domain_name = aws_s3_bucket_website_configuration.hosting.website_endpoint
    origin_id   = aws_s3_bucket.website.bucket_regional_domain_name



    custom_origin_config {
      http_port  = 80
      https_port = 443
      #   origin_keepalive_timeout = 5
      origin_protocol_policy = "http-only"
      #   origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    # CachingOptimized managed cache policy. 
    # See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized.
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.website.bucket_regional_domain_name

  }
}
