terraform {
  backend "s3" {
    bucket = "wlevan3-cloud-resume-challenge-development"
    key    = "devterraform.tfstate"
    region = "us-west-1"
  }
}
