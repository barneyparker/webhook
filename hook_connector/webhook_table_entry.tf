resource "aws_dynamodb_table_item" "pipeline_entry" {
  table_name = "webhook_repositories"
  hash_key   = "repository"

  item = <<-ITEM
    {
      "repository": {"S": "${var.organisation_name}/${var.repository_name}"},
      "pipeline": {"S": "${var.pipeline_name}"},
      "OAuthParameter": {"S": "${var.token_parameter}"}
    }
  ITEM
}