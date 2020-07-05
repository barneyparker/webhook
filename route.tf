resource "aws_apigatewayv2_route" "route" {
  api_id             = aws_apigatewayv2_api.github_webhook.id
  route_key          = "$default"
  target             = "integrations/${aws_apigatewayv2_integration.integration.id}"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id           = aws_apigatewayv2_api.github_webhook.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "Github Webhook Handler"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior = "WHEN_NO_MATCH"

  lifecycle {
    ignore_changes = [
      passthrough_behavior
    ]
  }
}
