variable "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static website"
  type        = string
  default     = "wlevan3-cloud-resume-challenge"
}

variable "env" {
  description = "Environment (e.g. `development`, `production`)"
  type        = string
}
