provider "aws" {
  region  = "eu-central-1"
  profile = "terraform"
  default_tags {
    tags = {
      Owner = "Ognjen Dacevic"
    }
  }
}
