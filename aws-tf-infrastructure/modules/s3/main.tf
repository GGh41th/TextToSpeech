resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "lambda-data-bucket-00033" 
}


resource "aws_s3_object" "lambda_script" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key    = "lambda/script"
    source = "${path.root}/lambda/lambda.zip"
}


resource "aws_s3_object" "lambda_layer" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key    = "lambda/layer"
    source = "${path.root}/lambda/python.zip"
}

