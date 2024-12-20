

# the code of the lambda will be provided by the an s3 bucket under they key s3_key and the layers will be provided
# by the ressource aws_lambda_layer_version under the s3_key argument in that block.

resource "aws_lambda_function" "lambda_polly" {
    function_name = "polly-lambda-function"
    role          = var.lambda_role_arn
    handler       = "lambda.lambda_handler"
    runtime       = "python3.13" 
    s3_bucket = var.s3_bucket
    s3_key    = "lambda/script"
    layers = [aws_lambda_layer_version.lambda_layers.arn]

}


resource "aws_lambda_layer_version" "lambda_layers" {
    layer_name          = "dependencies-layers"
    compatible_runtimes = ["python3.13"]
    s3_bucket           = var.s3_bucket
    s3_key              = "lambda/layer"
}


