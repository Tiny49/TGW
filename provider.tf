terraform {
  required_version = ">= 1.2.3"

  backend "s3" {
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "aws" {
  region  = var.region
}
