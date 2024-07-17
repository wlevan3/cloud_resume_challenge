locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript"
  }


  frontend_path = "${path.root}/../../frontend"
  current_time  = formatdate("YYYY-MM-DD-hhmmss", timestamp())
}


output "s3_bucket" {
  value = aws_s3_bucket.website
}


resource "aws_s3_bucket" "website" {
  bucket = "${var.s3_bucket_name}-${var.env}"
}


resource "aws_kms_key" "key" {
  description         = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
}

resource "aws_kms_alias" "key" {
  target_key_id = aws_kms_key.key.id
  name          = "alias/${var.s3_bucket_name}-${local.current_time}"
}



resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
#   bucket = aws_s3_bucket.website.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }



# resource "aws_s3_bucket_policy" "bucket_policy" {
#   depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
#   bucket     = aws_s3_bucket.website.id
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid" : "PublicReadGetObject",
#           "Effect" : "Allow",
#           "Principal" : "*",
#           "Action" : "s3:GetObject",
#           "Resource" : "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
#         }
#       ]
#     }
#   )
# }

resource "aws_s3_bucket_policy" "allow_access_from_specific_role" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
      },
      {
        Sid       = "AllowSpecificRoleAccess1"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = ["${aws_s3_bucket.website.arn}/*", "${aws_s3_bucket.website.arn}"]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "98.255.239.145/32"
          }
        }
      }
    ]
  })
}


resource "aws_s3_object" "file" {
  for_each     = fileset(local.frontend_path, "*.{html,css,js}")
  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  source_hash  = filemd5(each.value)
}

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

