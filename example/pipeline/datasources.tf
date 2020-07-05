data "aws_ssm_parameter" "github_org" {
  name = "/github/organisation"
}

data "aws_ssm_parameter" "github_token" {
  name = "/github/token"
}