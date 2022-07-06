provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

resource "aws_default_vpc" "default" {}
