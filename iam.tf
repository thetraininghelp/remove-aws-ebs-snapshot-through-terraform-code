resource "aws_iam_role" "lambda_role" {
  name = "lambda_delete_snapshots_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  tags = local.tags
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_delete_snapshots_policy"
  description = "IAM policy for Lambda to delete snapshots"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshots"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}