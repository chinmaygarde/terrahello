# This is where providers are defined.

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}