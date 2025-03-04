# i highly recommend reading the documentation for the different ressources used here, especially the "aws_api_gateway_deployment"
# since it involves a lot of best practices and tips that explains a lot of errors that could be faced while creating and deploying 
# your api.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment


resource "aws_api_gateway_rest_api" "lambda_polly_api" {
  name        = "lambda_polly_api"
  description = "API Gateway with CORS and Lambda integration"
}


resource "aws_api_gateway_resource" "polly_lambda" {
  rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_polly_api.root_resource_id
  path_part   = "polly-endpoint"
}


resource "aws_api_gateway_deployment" "api_dep" {
  rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
  # use the tirggers argument instead of the depends_on , check the documentation
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.polly_lambda.id,
      aws_api_gateway_method.polly_lambda_method.id,
      aws_api_gateway_integration.api_lambda_integration.id,
      aws_api_gateway_method.cors.id,
      aws_api_gateway_integration.cors.id,
      aws_api_gateway_method_response.cors.id,
      aws_api_gateway_integration_response.cors.id,
      aws_api_gateway_method_response.post_method_response.id,
      aws_api_gateway_integration_response.post_integration_response.id
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_dep.id
  rest_api_id   = aws_api_gateway_rest_api.lambda_polly_api.id
  stage_name    = "test"
}

# The next 4 ressources are handling a post method (This method acts as the trigger for the lambda's invocation) ,
# in addition to its integration , its response  and the response integration


resource "aws_api_gateway_method" "polly_lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id   = aws_api_gateway_resource.polly_lambda.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id             = aws_api_gateway_resource.polly_lambda.id
  http_method             = aws_api_gateway_method.polly_lambda_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.lambda_uri
}


resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id = aws_api_gateway_resource.polly_lambda.id
  http_method = aws_api_gateway_method.polly_lambda_method.http_method # POST method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true # Include if needed for POST
  }
}

resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id = aws_api_gateway_resource.polly_lambda.id
  http_method = aws_api_gateway_method.polly_lambda_method.http_method
  status_code = "200"
  response_templates = {
    "application/json" = "" 
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'" 
  }
 depends_on = [aws_api_gateway_integration.api_lambda_integration]

}


# The next 4 ressources are handling an OPTION method (This method enables the CORS in order to be able to connect to the api endpoint) ,
# in addition to its integration , its response  and the response integration



resource "aws_api_gateway_method" "cors" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id   = aws_api_gateway_resource.polly_lambda.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id             = aws_api_gateway_resource.polly_lambda.id
  http_method             = aws_api_gateway_method.cors.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
  resource_id = aws_api_gateway_resource.polly_lambda.id
  http_method = aws_api_gateway_method.cors.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "cors" {
    rest_api_id = aws_api_gateway_rest_api.lambda_polly_api.id
    resource_id = aws_api_gateway_resource.polly_lambda.id
    http_method = aws_api_gateway_method.cors.http_method
    status_code = "200"
    depends_on = [ aws_api_gateway_integration.cors ]
    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
        "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'"
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    }
}



resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.lambda_polly_api.execution_arn}/*"
}