terraform {
  required_version = "> 0.12"
}

provider "aws" {
  version = ">= 2.61.0"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_acm_certificate" "cert" {
  domain   = "barneyparker.com"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name         = "barneyparker.com."
  private_zone = false
}