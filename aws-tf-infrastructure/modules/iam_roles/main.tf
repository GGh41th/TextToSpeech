resource "aws_iam_role" "lambda_role" {
    name = "s3-read-role"

    assume_role_policy = jsonencode({
        Version : "2012-10-17",
        Statement: [
        {
            Effect    : "Allow",
            Principal : { Service: "lambda.amazonaws.com" },
            Action    : "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "s3_read_only_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# Create a Policy for full Polly access
resource "aws_iam_policy" "polly_full_access" {
    name        = "lambda-polly-full-access"
    description = "Policy to allow Lambda full access to Amazon Polly"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect   = "Allow",
            Action   = "polly:*",
            Resource = "*"
        }
        ]
    })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_polly_policy_to_role" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.polly_full_access.arn
}


resource "aws_iam_role" "cognito_identity_pool_role" {
    name               = "cognito_identity_pool_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            Federated = "cognito-identity.amazonaws.com"
            }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condition = {
            StringEquals = {
                "cognito-identity.amazonaws.com:aud" = "${var.cognito_identity_pool_id}"
            }
            "ForAnyValue:StringLike" = {
                "cognito-identity.amazonaws.com:amr" = "unauthenticated"
            }
            }
        }
        ]
    })
}



resource "aws_iam_policy" "cognito_polly_read_only_policy" {
    name        = "CognitoPollyReadOnlyPolicy"
    description = "Policy for Cognito users to access Polly with read-only permissions"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect   = "Allow"
            Action   = [
            "polly:DescribeVoices"
            ]
            Resource = "*"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "cognito_polly_policy_attachment" {
    role       = aws_iam_role.cognito_identity_pool_role.name
    policy_arn = aws_iam_policy.cognito_polly_read_only_policy.arn
}




# Policy for allowing Cognito to manage identities
resource "aws_iam_policy" "cognito_identity_pool_policy" {
  name        = "cognito-identity-pool-policy"
  description = "Policy for Cognito Identity Pool to manage identities"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-identity:GetId",
          "cognito-identity:GetCredentialsForIdentity",
          "cognito-identity:DescribeIdentity",
          "cognito-identity:ListIdentities",
          "cognito-identity:LookupDeveloperIdentity",
          "cognito-sync:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "cognito_identity_pool_policy_attachment" {
  role       = aws_iam_role.cognito_identity_pool_role.name
  policy_arn = aws_iam_policy.cognito_identity_pool_policy.arn
}
