terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "arconsis-benchmarks"
    workspaces {
      name = "server-benchmarks-ecr"
    }
  }

  required_version = ">= 1.5"
}
