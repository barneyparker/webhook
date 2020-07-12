variable "repository_name" {
  type        = string
  description = "Name of the GitHub Repository"
}

variable "organisation_name" {
  type        = string
  description = "GitHub Organisation Name"
}

variable "token_parameter" {
  type        = string
  description = "SSM Parameter Name for OAuth Token"
}
variable "hook_url" {
  type        = string
  description = "URL of the Git Webhook"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the main CodePipeline"
}