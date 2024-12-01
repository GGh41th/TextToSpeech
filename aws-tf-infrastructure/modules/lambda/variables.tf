variable "lambda_role_arn" {
    description = "iam role arn for lambda function"
    type=string
}

variable "s3_bucket" {
    description = "s3 bucket for storing lambda code and layers"
    type=string
}

