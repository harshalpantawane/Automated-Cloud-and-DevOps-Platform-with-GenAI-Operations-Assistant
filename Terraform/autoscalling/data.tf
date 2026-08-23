data "aws_ami" "linux_2023" {
  most_recent = true

  filter {
    name = "name"
    values = ["al2023-ami-2023.10.20260302.1-kernel-6.1-x86_64"]
  }

  filter{
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = [""]
}

data "aws_ssm_parameter" "rds_db_passwd" {
  name = var.rds_db_parameter_name
  with_decryption = true
}

data "terraform_remote_state" "app_buckets" {
  backend = "s3"

  config = {
    bucket = "project-gen-ai-tfstate"
    key = "envs/dev/app/terraform.tfstate"
    region = "us-east-1"
  }
}