locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript"
  }


  frontend_path = "${path.root}/../../frontend"
  current_time  = formatdate("YYYY-MM-DD-hhmmss", timestamp())
}

resource "aws_s3_bucket" "website_domain" {
  bucket = "walterlevan.com"
}

resource "aws_s3_bucket_policy" "allow_all" {
  bucket = aws_s3_bucket.website_domain.id

  policy = data.aws_iam_policy_document.allow_access_from_another_account.json

}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.website_domain.arn}/*"
    ]
  }
}
resource "aws_s3_bucket" "website_logs" {
  bucket = "logs.walterlevan.com"
}


resource "aws_s3_bucket" "website_subdomain" {
  bucket = "www.walterlevan.com"
}



resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.website_domain.id

  index_document {
    suffix = "index.html"
  }
}


