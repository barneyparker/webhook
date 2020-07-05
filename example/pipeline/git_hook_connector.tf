module "git_hook_connector" {
  source = "../../hook_connector"

  hook_url = "https://webhook.barneyparker.com"
  pipeline_name = aws_codepipeline.pipeline.name
  repository_name = var.repository_name
  organisation_name = data.aws_ssm_parameter.github_org.value
  token_parameter = data.aws_ssm_parameter.github_token.name
}