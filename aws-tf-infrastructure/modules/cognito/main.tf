
# create an identity pool to provide temporary credentials to be able to fetch the voices from polly 
resource "aws_cognito_identity_pool" "cognito_idp" {
    identity_pool_name               = "example_identity_pool"
    allow_unauthenticated_identities = true
    
}

resource "aws_cognito_identity_pool_roles_attachment" "role1" {
  identity_pool_id = aws_cognito_identity_pool.cognito_idp.id
  roles = {
    # the app was developed under the assumptions that users are guests , thats why we used the value "unauthenticated" here 
    # if the app is accepting authenticated users it needs to be changed accordignly , check the documentation for further instructions
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment
    "unauthenticated" = var.cognito_identity_pool_role
}
}
