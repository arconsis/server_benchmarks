terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
  }

  cloud {
    organization = "arconsis-benchmarks"
    workspaces {
      name = "server-benchmarks"
    }
  }

  required_version = ">= 1.5"
}
