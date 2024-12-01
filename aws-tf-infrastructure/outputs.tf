output "cognito_identity_pool_id" {
  value       = module.cognito.cognito_identity_pool_id
  description = "The Cognito Identity Pool ID from the cognito module."
}

output "api_gateway_endpoint" {
  value       = module.api_gateway.api_gateway_endpoint
  description = "The API Gateway endpoint URL from the api_gateway module."
}
