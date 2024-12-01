resource "aws_cognito_identity_pool" "cognito_idp" {
    identity_pool_name               = "example_identity_pool"
    allow_unauthenticated_identities = true
    
}

resource "aws_cognito_identity_pool_roles_attachment" "role1" {
  identity_pool_id = aws_cognito_identity_pool.cognito_idp.id

  roles = {
    "unauthenticated" = var.cognito_identity_pool_role
}
}
