terraform {
  required_version = ">=1.0"

  backend "s3" {
    region = "eu-central-1"
    bucket = "tnlinc"
    key    = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
