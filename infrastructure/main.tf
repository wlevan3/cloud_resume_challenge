module "frontend" {
  source = "./modules/frontend"

  s3_bucket_name = var.s3_bucket_name
  env            = var.env
}



import {
  to = module.frontend.aws_s3_bucket.website
  id = "wlevan3-cloud-resume-challenge-development"
}

import {
  to = module.frontend.aws_cloudfront_distribution.distribution
  id = "E1J7ZKEMNPIO1S"
}



output "path" {
  value = module.frontend.path

}

output "frontend" {
  value = module.frontend.s3_bucket
}

output "cf_url" {
  description = "CLOUDFRONT URL FROM ROOT OUTPUT"
  value       = module.frontend.website_url
}
