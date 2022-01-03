variable "vpc_id" {
  type = string
  default = "vpc-05fdaa7602cde8c86"
  description = "VPC Id to create resources in"
}
variable "lambda_subnet_ids" {
  type = list(string)
  default = [ "subnet-0f7716fc7bb1c47a0" ]
  description = "One or more Subnet id for Lambda function"
}
variable "lambda_function_runtime" {
  type = string
  default = "dotnetcore3.1"
  description = "Lambda function runtime e.g python3.9"  
}
variable "lambda_max_memory" {
  type = number
  default = 800
  description = "Amount of Memory in MBs your Lambda Function can use at runtime"
}
variable "lambda_timeout" {
  type = number
  default = 500
  description = "Amount of time your Lambda Function has to run in seconds."
}
#################################
#           API vars            #
#################################
variable "stage_name"{
  type = string
  default = ""
  description = "API stage 01 name"
}
variable "api_01" {
  type = string
  default = ""
  description = "api name 01"
}
variable "enable_api_xray"{
  type = string
  default = true
  description = "Enable xray for api gateway"
}
variable "authorizer_lambda_arn" {
  type = string
  # default = ""
  description = "Authorizer lambda function arn (Leave empty if not applicable)"
}
variable "tags"{
  type = map(string)
  default = {
  }
}