#--------------------------------------------------------------
# Lambda Permissions definitions
#--------------------------------------------------------------
data "aws_iam_policy_document" "donald_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "donald_lambda" {
  name               = "${var.prefix}-donald-Assume-Role-for-Lambda"
  assume_role_policy = data.aws_iam_policy_document.donald_lambda_assume_role.json
}

data "aws_iam_policy_document" "dso_lambda" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/object1.json",
      "arn:aws:s3:::${var.bucket_name}/object2.json",
      "arn:aws:s3:::${var.bucket_name}/object3.json",
    ]
  }
}

resource "aws_iam_policy" "donald_lambda" {
  name   = "${var.prefix}-donald-lambda"
  path   = "/"
  policy = data.aws_iam_policy_document.donald_lambda.json
}

resource "aws_iam_policy_attachment" "donald_lambda" {
  name       = "${var.prefix}-donald-lambda"
  roles      = [aws_iam_role.donald_lambda.name]
  policy_arn = aws_iam_policy.donald_lambda.arn
}


#--------------------------------------------------------------
# Cloudwatch Logs definitions
#--------------------------------------------------------------
data "aws_iam_policy_document" "donald_lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.prefix}_DSO_Demo_Lambda:log-stream:*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.prefix}_DSO_Demo_Lambda",

    ]
  }
}

resource "aws_iam_policy" "donald_lambda_logging" {
  name        = "donald_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.donald_lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "donald_lambda_logs" {
  role       = aws_iam_role.donald_lambda.name
  policy_arn = aws_iam_policy.donald_lambda_logging.arn
}
