variable "region" {
    description = "aws region"
    type        = string
    default = "eu-west-3"
}


variable "stage" {
    description = "api gateway stage for deploying the lambda trigger api"
    type        = string
    default = "test"
}

variable "ressource" {
    description = "the endpoint for trigerring lambda"
    type        = string
    default = "polly-endpoint"
}

variable "lambda_uri" {
    description = "the uri for the lambda function"
    type        = string
}

variable "lambda_name" {
    description = "the name for the lambda function"
    type        = string
}