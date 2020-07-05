data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/.terraform/${var.api_name}-handler.zip"
  source_dir  = "${path.module}/src"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "${var.api_name}-handler"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs12.x"
  handler = "index.handler"

  environment {
    variables = {
      repository_table = aws_dynamodb_table.repositories.name
    }
  }

  role = aws_iam_role.lambda.arn
}

resource "aws_iam_role" "lambda" {
  name               = "${var.api_name}-handler"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          }
        }
      ]
    }
  EOF
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "APIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.github_webhook.id}/*/*"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "GitHub_Webhook_Handler_Policy"
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["dynamodb:GetItem"]
    resources = ["${aws_dynamodb_table.repositories.arn}"]
  }

  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }

  statement {
    actions = [
      "codepipeline:GetPipeline",
      "codepipeline:CreatePipeline",
      "codepipeline:TagResource",
      "codepipeline:DeletePipeline",
      "codepipeline:StartPipelineExecution"
    ]
    resources = ["arn:aws:codepipeline:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_retention
}