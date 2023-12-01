terraform {
  backend "s3" {
    bucket         = "aeternity-terraform-states"
    key            = "ae-aehc-demo.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}

# Default
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "eu-north-1"
  alias  = "eu-north-1"
}
