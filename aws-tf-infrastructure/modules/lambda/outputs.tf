output "lambda_uri" {
    value = aws_lambda_function.lambda_polly.invoke_arn
    description = "the lambda function uri , that will be used by the api gateway for integration"
}

output "lambda_name" {
    value = aws_lambda_function.lambda_polly.function_name
    description = "the lambda function uri , that will be used by the api gateway for integration"
}