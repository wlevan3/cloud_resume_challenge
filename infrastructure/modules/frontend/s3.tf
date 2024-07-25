locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript"
  }


  frontend_path = "${path.root}/../../frontend"
  current_time  = formatdate("YYYY-MM-DD-hhmmss", timestamp())
}

output "path" {
  value = local.frontend_path
}

output "s3_bucket" {
  value = aws_s3_bucket.website
}


resource "aws_s3_bucket" "website" {
  bucket = "${var.s3_bucket_name}-${var.env}"
}


resource "aws_s3_bucket_policy" "allow_access_from_specific_role" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "PublicReadGetObject",
            "Effect" : "Allow",
            "Principal" : "*",
            "Action" : [
              "s3:GetObject"
            ],
            "Resource" : [
              "${aws_s3_bucket.website.arn}/*"
            ]
          }
        ]
      },
      {
        Sid       = "AllowSpecificRoleAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = ["${aws_s3_bucket.website.arn}/*", "${aws_s3_bucket.website.arn}"]
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::523671527743:role/GithubActionsCICD"
          }
        }
      }
    ]
  })
}


resource "aws_s3_object" "file" {
  bucket  = aws_s3_bucket.website.id
  key     = "index.html"
  content = data.local_file.index.content
}

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}


data "local_file" "index" {
  filename = "${path.root}/../frontend/index.html"
}
