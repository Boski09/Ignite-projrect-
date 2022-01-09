variable "env"{
    default     = "dev"
    description = "Environment name" 
}
variable "api_name"{
    type = string
    description = "API name"
}
variable "api_endpoint_type"{
    type = string
    description = "API endpoint type. REGIONAL, EDGE or PRIVATE"
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
variable "stage_name"{
    type = string
    description = "API stage name to deploy API"
}
variable "api_key_value" {
  type        = string
  sensitive   = true
  description = "API Key Value"
}
variable "api_key_name" {
  type        = string
  /* default     = "" */
  description = "API Key Name"
}
variable "key_type" {
  default = "API_KEY"
}
variable "stage_01_name"{
    description = "API stage name"
}
variable "tags" {
  type        = map(string)
  description = "Tags to attach to resources"
}