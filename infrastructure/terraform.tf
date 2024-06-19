terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.48.0"
        }
        helm = {
            source = "hashicorp/helm"
            version = "~> 2.13.2"
        }
    }
}