resource "aws_iam_role" "ec2_role" {
  name = "flo-ec2-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "flo-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# NEW: Custom IAM policy for Terraform S3 + DynamoDB backend access
resource "aws_iam_policy" "terraform_backend_access" {
  name = "TerraformBackendAccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::do-assessment3-movie-db-flo",
          "arn:aws:s3:::do-assessment3-movie-db-flo/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ],
        Resource = "arn:aws:dynamodb:us-east-1:*:table/terraform-lock-table"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_backend_access_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.terraform_backend_access.arn
}
