provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = var.aws_profile
  region                   = var.aws_region
  #  default_tags {
  #    tags = var.default_tags
  #  }
}