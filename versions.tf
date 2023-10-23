terraform {
  required_version = ">= 1.0, < 2.0"

  required_providers {
    archive = {
      source                = "hashicorp/archive"
      version               = "= 2.4.0"
    }
    aws = {
      source                = "hashicorp/aws"
      version               = "= 4.67.0"
    }
    local = {
      source                = "hashicorp/local"
      version               = "= 2.4.0"
    }
    random = {
      source                = "hashicorp/random"
      version               = "= 3.5.1"
    }
    time = {
      source                = "hashicorp/time"
      version               = "= 0.9.1"
    }
  }
}
