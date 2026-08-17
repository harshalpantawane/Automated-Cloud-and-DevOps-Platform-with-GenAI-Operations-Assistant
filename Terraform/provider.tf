provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "realestate-bucket"
    key = "envs/dev/infra/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}