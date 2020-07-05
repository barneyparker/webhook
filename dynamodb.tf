resource "aws_dynamodb_table" "repositories" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "repository"

  attribute {
    name = "repository"
    type = "S"
  }
}