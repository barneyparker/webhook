resource "random_string" "random" {
  length = 16
  special = false
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "webhook" {
  repository = var.repository_name

  configuration {
    url          = var.hook_url
    content_type = "json"
    insecure_ssl = false
    secret       = random_string.random.result
  }

  active = true
  events = ["*"]

  depends_on = [aws_dynamodb_table_item.pipeline_entry]
}
