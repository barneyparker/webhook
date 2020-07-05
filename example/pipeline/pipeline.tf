resource "aws_codepipeline" "pipeline" {
  name     = "webhook_pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.asset_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = 1
      output_artifacts = ["source"]
      configuration = {
        Owner                = data.aws_ssm_parameter.github_org.value
        Repo                 = var.repository_name
        OAuthToken           = data.aws_ssm_parameter.github_token.value
        Branch               = "master"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name            = "Approval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      input_artifacts = []
      version         = 1

      configuration = {
        CustomData : "Approve Me!!!",
        #ExternalEntityLink: "http://my-url.com",
        #NotificationArn: "arn:aws:sns:us-west-2:12345EXAMPLE:Notification"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      stage.0.action.0.configuration.OAuthToken,
      stage.0.action.0.configuration
    ]
  }
}

resource "aws_iam_role" "pipeline" {
  name = "webhook-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "pipeline_policy" {
  name = "pipeline_policy"
  role = aws_iam_role.pipeline.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.asset_bucket.arn}",
        "${aws_s3_bucket.asset_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}