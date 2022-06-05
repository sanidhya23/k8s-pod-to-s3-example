
resource "aws_iam_policy" "my-app-s3-policy" {
  name        = "my-app-s3-policy"
  description = "my-app-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      },
    ]
  })
}


output "policy_arn" {
  value       = aws_iam_policy.my-app-s3-policy.arn
  description = "Policy created for read-write in S3 bucket"
}

