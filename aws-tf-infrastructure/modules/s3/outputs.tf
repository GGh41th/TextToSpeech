output "s3_bucket" {
    value = aws_s3_bucket.lambda_bucket.bucket
}

output "s3_function_key" {
  value = aws_s3_object.lambda_script.key
}

output "s3_layer_key" {
  value = aws_s3_object.lambda_layer.key
}