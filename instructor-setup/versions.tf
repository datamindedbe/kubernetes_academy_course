terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.13.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.18.1"
    }
  }

  required_version = "= 1.5.5"
}

