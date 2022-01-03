# output "lambda_function_name" {
#     value = module.api_lambda_function_authorizer.lambda_function_invoke_arn
# }
# output "test" {
#     value = "arn:aws:apigateway:${data.aws_region.aws-region.name}:lambda:path/2015-03-31/functions/${var.authorizer_lambda_arn}/invocations"
# }