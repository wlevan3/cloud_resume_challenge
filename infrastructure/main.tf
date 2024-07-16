module "frontend" {
  source = "./modules/frontend"

  s3_bucket_name = var.s3_bucket_name
  env            = var.env
}

