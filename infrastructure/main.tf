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



# output "path" {
#   value = module.frontend.path

# }

# output "frontend" {
#   value = module.frontend.s3_bucket
# }

output "domain_name_from_root" {
  description = "domain_name_from_root"
  value       = module.frontend.domain_name
}
