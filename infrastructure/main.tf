module "frontend" {
  source = "./modules/frontend"

  s3_bucket_name = var.s3_bucket_name
  env            = var.env
}



import {
  to = module.frontend.aws_s3_bucket.website
  id = "wlevan3-cloud-resume-challenge-development"
}
