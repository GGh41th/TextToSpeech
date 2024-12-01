
output "api_gateway_endpoint" {
    value = "https://${aws_api_gateway_rest_api.lambda_polly_api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}/${var.ressource}"
}


