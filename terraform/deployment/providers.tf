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
      project = "server-benchmarks"
      name    = "server-benchmarks"
    }
  }

  required_version = ">= 1.0"
}
