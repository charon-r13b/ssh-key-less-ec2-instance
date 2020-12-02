terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.18"
    }
  }
  required_version = ">= 0.13"
}
