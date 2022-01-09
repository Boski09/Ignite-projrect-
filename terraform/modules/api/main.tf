data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "api_auth" {
  name = "${var.api_name}-api-auth-invocation-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "api_auth" {
  name   = "api-auth-invocation"
  role   = aws_iam_role.api_auth.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "arn:aws:lambda:*"
    }
  ]
}
EOF
}
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_name
  endpoint_configuration {
    types = [var.api_endpoint_type]
  }
  body = file("${path.module}/swagger.json")
  tags = var.tags
}

#API deployment
 resource "aws_api_gateway_deployment" "api_deployment_01" {
   rest_api_id       = aws_api_gateway_rest_api.api.id
   description       = "Deployed at ${timestamp()}"
   stage_name        = var.stage_name
   stage_description = "Deployed at ${timestamp()}"
 }
 resource "aws_api_gateway_stage" "api_stage_01" {
   deployment_id = aws_api_gateway_deployment.api_deployment_01.id
   rest_api_id   = aws_api_gateway_rest_api.api.id
   stage_name    = var.stage_01_name
   description   = "Deployed at ${timestamp()}"
 }

resource "aws_api_gateway_api_key" "api_key" {
  count = var.api_key_value == "" ? 0 : 1
  name  = var.api_key_name
  value = var.api_key_value
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  count = var.api_key_value == "" ? 0 : 1
  depends_on = [aws_api_gateway_rest_api.api]

  name = "${var.env}-Plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.api_stage_01.stage_name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan_key" "api_usgae_plan_key" {
  count         = var.api_key_value == "" ? 0 : 1
  key_id        = aws_api_gateway_api_key.api_key[count.index].id
  key_type      = var.key_type
  usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan[count.index].id
}

#Lambda permission 01
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromApi01"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    =    "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}*"
}
#Lambda permission 02
resource "aws_lambda_permission" "lambda_permission_02" {
  statement_id  = "AllowExecutionFromApi02"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_02
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}*"

}
#Lambda permission 03
resource "aws_lambda_permission" "lambda_permission_03" {
  statement_id  = "AllowExecutionFromApi03"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_03
  principal     = "apigateway.amazonaws.com"
  source_arn    =   "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}*"
}