data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}


# module "dynamodb" {
#   source                = "../dynamodb"
#   # project               = var.project
#   # env                   = "${terraform.workspace}"
#   region                = data.aws_region.aws-region.name
#   dynamodb_table_name   = "Order"
#   dynamo_billing_mode   = "PROVISIONED"
#   dynamo_write_capacity = 5
#   dynamo_read_capacity  = 10
#   hash_key              = "id"
#   hash_key_type         = "S"
#   range_key             = "name"
#   range_key_type        = "N"
#   tags                  = var.tags
# }

module "lambda_function_01" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CP_File_Get"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
module "lambda_function_02" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CP_File_Update"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
module "lambda_function_03" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CP_File_GetHistory"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}
# module "lambda_function_04" {
#   source   = "../lambda"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "Name_Here"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../lambda/lambda_function.zip"
#   lambda_env_variables           = {}
#   publish_lambda                 = true
#   tags                           = var.tags
# }

module "api_lambda_function_authorizer" {
  # count = var.authorizer_lambda_arn != null ? 0 : 1
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CPAPI-Authorizer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}


module "api" {
    source                          = "../api"
    api_name                        = "CPAPI"
    authorizer_lambda_invoke_arn    = module.api_lambda_function_authorizer.lambda_function_invoke_arn
    # authorizer_lambda_invoke_arn    = var.authorizer_lambda_arn != null ? "arn:aws:apigateway:${data.aws_region.aws-region.name}:lambda:path/2015-03-31/functions/${var.authorizer_lambda_arn}/invocations" : module.api_lambda_function_authorizer.lambda_function_invoke_arn
    lambda_invoke_arn               = module.lambda_function_01.lambda_function_invoke_arn
    lambda_name                     = module.lambda_function_01.lambda_function_name
    lambda_name_02                  = module.lambda_function_02.lambda_function_name
    lambda_invoke_arn_02            = module.lambda_function_02.lambda_function_invoke_arn
    lambda_name_03                  = module.lambda_function_03.lambda_function_name
    lambda_invoke_arn_03            = module.lambda_function_03.lambda_function_invoke_arn
   
    stage_name                      = "dev"
    tags                            = var.tags
}