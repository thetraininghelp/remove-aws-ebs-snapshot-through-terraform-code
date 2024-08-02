resource "aws_lambda_function" "delete_snapshots" {
  filename      = "lambda_function.zip"
  function_name = "delete_snapshots_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.8"
  timeout       = 30

  source_code_hash = filebase64sha256("lambda_function.zip")
  tags = local.tags
}

resource "aws_lambda_invocation" "invoke_lambda" {
  function_name = aws_lambda_function.delete_snapshots.function_name
  count         = length(var.snapshot_ids)

  input = jsonencode({
    snapshot_id = element(var.snapshot_ids, count.index)
  })

  depends_on = [
    aws_lambda_function.delete_snapshots
  ]
}

