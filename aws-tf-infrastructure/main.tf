module "cognito" {
    source = "./modules/cognito"
    cognito_identity_pool_role = module.iam_roles.cognito_identity_pool_role
}

module "api_gateway" {
    source = "./modules/api_gateway"
    lambda_uri = module.lambda.lambda_uri
    lambda_name = module.lambda.lambda_name
}

module "iam_roles" {
    source = "./modules/iam_roles"
    cognito_identity_pool_id = module.cognito.cognito_identity_pool_id
}

module "lambda" {
    source = "./modules/lambda"
    s3_bucket = module.s3.s3_bucket
    lambda_role_arn = module.iam_roles.lambda_role_arn
}

module "s3" {
    source = "./modules/s3"
}

module "global" {
    source = "./global"
}