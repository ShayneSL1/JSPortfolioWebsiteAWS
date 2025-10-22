provider "aws" {
    region = "us-east-2"
}

#S3 Bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "nextjs-portfolio-bucket-sl"
  
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  
  tags = {
    Name = "Portfolio Website"
    Environment = "Production"
  }
}

#Ownership Control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Allow Public Access
resource "aws_s3_account_public_access_block" "nextjs_bucket_public_access_block" {
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

#Bucket ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  acl = "public-read"
  depends_on = [ 
    aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_controls,
    aws_s3_account_public_access_block.nextjs_bucket_public_access_block
   ]
}

#Bucket Policy
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.nextjs_bucket.website_endpoint
    origin_id   = "S3-Website"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  tags = {
    Name = "Portfolio CloudFront"
    Environment = "Production"
  }
}


