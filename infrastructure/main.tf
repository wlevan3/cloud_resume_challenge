module "frontend" {
  source = "./modules/frontend"

  s3_bucket_name = var.s3_bucket_name
  env            = var.env
}



import {
  to = module.frontend.aws_s3_bucket.website
  id = "wlevan3-cloud-resume-challenge-development"
}


output "frontend_path" {
  value = module.frontend.local.frontend_path
}

output "s3_link" {
  value = module.frontend.aws_s3_bucket.website.website_endpoint
}
