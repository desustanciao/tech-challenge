terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }
  required_version = ">= 1.14"
  
  backend "s3" {
    bucket         = "terraform-state-tech-challenge-bizzaway"  # Replace with your bucket name
    key            = "eks/terraform.tfstate"                    # Path inside the bucket
    region         = "eu-south-2"                               # AWS region for the S3 bucket
    encrypt        = true                                       # Encrypt the state at rest
  }

}

provider "aws" {
  region = var.aws_region
}
