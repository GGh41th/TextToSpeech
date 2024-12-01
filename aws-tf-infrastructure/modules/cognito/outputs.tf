output "cognito_identity_pool_id" {
    value = aws_cognito_identity_pool.cognito_idp.id
    description = "The Cognito Identity Pool ID."
}