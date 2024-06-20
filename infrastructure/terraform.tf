terraform {
    backend "s3" {
        bucket         = "ognjen-terraform-backend"
        key            = "terraform.tfstate"
        region         = "eu-central-1"
        dynamodb_table = "terraform-lock"
        encrypt        = true
        profile        = "terraform"
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.48.0"
        }
    }
}