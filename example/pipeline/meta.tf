terraform {
  required_version = "> 0.12"
}

provider "aws" {
  region  = "eu-west-1"
  version = ">= 2.61.0"
}

provider "github" {
  version      = "= 2.4.1" # Non-org broken after this version
  organization = data.aws_ssm_parameter.github_org.value
  token        = data.aws_ssm_parameter.github_token.value
}