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
      "Resource": "${var.authorizer_lambda_invoke_arn}"
    }
  ]
}
EOF
}
resource "aws_api_gateway_authorizer" "api_auth" {
  name                             = "api-authorizer"
  type                             = "TOKEN"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  authorizer_uri                   = var.authorizer_lambda_invoke_arn
  authorizer_credentials           = aws_iam_role.api_auth.arn
  authorizer_result_ttl_in_seconds = 0
}


resource "aws_api_gateway_rest_api" "api" {
  name        =  var.api_name
  description = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = var.tags
}

#/api
resource "aws_api_gateway_resource" "api_rsc_01" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "api"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1
resource "aws_api_gateway_resource" "api_rsc_02" {
  parent_id   = aws_api_gateway_resource.api_rsc_01.id
  path_part   = "v1"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1/file
resource "aws_api_gateway_resource" "api_rsc_03" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "file"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/api/v1/file/POST
resource "aws_api_gateway_method" "api_mthd_03" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_rsc_03.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_03" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_03.id
  http_method             = aws_api_gateway_method.api_mthd_03.http_method
  type                    = "AWS" #"AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_03" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_03.id
  http_method     = aws_api_gateway_method.api_mthd_03.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_03" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_03.id
  http_method = aws_api_gateway_method.api_mthd_03.http_method
  status_code = aws_api_gateway_method_response.api_mthd_03.status_code
}


#/api/v1/file/update
resource "aws_api_gateway_resource" "api_rsc_04" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "update"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/api/v1/file/update/POST
resource "aws_api_gateway_method" "api_mthd_04" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_rsc_04.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_04" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_04.id
  http_method             = aws_api_gateway_method.api_mthd_04.http_method
  type                    = "AWS" #"AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_02
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_04" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_04.id
  http_method     = aws_api_gateway_method.api_mthd_04.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_04" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_03.id
  http_method = aws_api_gateway_method.api_mthd_04.http_method
  status_code = aws_api_gateway_method_response.api_mthd_04.status_code
}


#/api/v1/filehistory
resource "aws_api_gateway_resource" "api_rsc_05" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "filehistory"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/api/v1/filehistory/POST
resource "aws_api_gateway_method" "api_mthd_05" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_rsc_05.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_05" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_05.id
  http_method             = aws_api_gateway_method.api_mthd_05.http_method
  type                    = "AWS" #"AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_03
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_05" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_05.id
  http_method     = aws_api_gateway_method.api_mthd_05.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_05" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_05.id
  http_method = aws_api_gateway_method.api_mthd_05.http_method
  status_code = aws_api_gateway_method_response.api_mthd_05.status_code
}


#/api/v1/resend
resource "aws_api_gateway_resource" "api_rsc_06" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "resend"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/api/v1/resend/POST
resource "aws_api_gateway_method" "api_mthd_06" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_rsc_06.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_06" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_06.id
  http_method             = aws_api_gateway_method.api_mthd_06.http_method
  type                    = "HTTP"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = "https://www.google.com/"
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_06" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_06.id
  http_method     = aws_api_gateway_method.api_mthd_06.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_06" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_06.id
  http_method = aws_api_gateway_method.api_mthd_06.http_method
  status_code = aws_api_gateway_method_response.api_mthd_06.status_code
}

#Lambda permission 01
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromApi01"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_03.http_method}${aws_api_gateway_resource.api_rsc_03.path}"
}
#Lambda permission 02
resource "aws_lambda_permission" "lambda_permission_02" {
  statement_id  = "AllowExecutionFromApi02"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_02
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_04.http_method}${aws_api_gateway_resource.api_rsc_04.path}"
}
#Lambda permission 03
resource "aws_lambda_permission" "lambda_permission_03" {
  statement_id  = "AllowExecutionFromApi03"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_03
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_05.http_method}${aws_api_gateway_resource.api_rsc_05.path}"
}

#API deployment
# resource "aws_api_gateway_deployment" "api_deployment" {
#   depends_on        = [aws_api_gateway_method.api_mthd_02]
#   rest_api_id       = aws_api_gateway_rest_api.api.id
#   description       = "Deployed at ${timestamp()}"
#   stage_name        = var.stage_name
#   stage_description = "Deployed at ${timestamp()}"
# }