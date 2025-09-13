terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # backend "s3" {
  #     bucket = "harii-81s-remote-state"
  #     key    = "expense-bastion"
  #     region = "us-east-1"
  #     dynamodb_table = "harii-81s-locking"
  # }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}