terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cloudzenia-oa-tf-state"
    key            = "cloudzenia-oa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cloudzenia-oa-tf-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}