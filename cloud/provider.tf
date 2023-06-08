terraform {
  required_version = ">=0.13"

  required_providers {
    hashicorp-time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }    
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias = "ireland"
  region = "eu-west-1"
}
# provider "aws" {
#   alias  = "virgina"
#   region = "us-east-1"
# }