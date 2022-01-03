variable "api_name"{
    type = string
    description = "API name"
}
variable "authorizer_lambda_invoke_arn"{
    type = string
    description = "Authorizer lambda invoke arn"
}
variable "lambda_invoke_arn"{
    type = string
    description = "Lambda invoke arn for api"
}
variable "lambda_name"{
    type = string
    description = "Lambda function name"
}
variable "lambda_invoke_arn_02"{
    type = string
    description = "Lambda invoke arn for api"
}
variable "lambda_name_02"{
    type = string
    description = "Lambda function name"
}
variable "lambda_invoke_arn_03"{
    type = string
    description = "Lambda invoke arn for api"
}
variable "lambda_name_03"{
    type = string
    description = "Lambda function name"
}
# variable "lambda_invoke_arn_04"{
#     type = string
#     description = "Lambda invoke arn for api"
# }
# variable "lambda_name_04"{
#     type = string
#     description = "Lambda function name"
# }
variable "stage_name"{
    type = string
    description = "API stage name to deploy API"
}
variable "tags" {
  type        = map(string)
  description = "Tags to attach to resources"
}