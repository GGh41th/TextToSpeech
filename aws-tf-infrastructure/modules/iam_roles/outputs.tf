output "lambda_role_arn" { 
 description = "iam role arn for lambda function"
 value = aws_iam_role.lambda_role.arn
}


output "cognito_identity_pool_role" {
    value = aws_iam_role.cognito_identity_pool_role.arn
}