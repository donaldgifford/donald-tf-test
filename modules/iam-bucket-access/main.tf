#--------------------------------------------------------------
# Assume Role 
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

data "aws_iam_policy_document" "donald_lambda_s3_access" {
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
  policy = data.aws_iam_policy_document.donald_lambda_s3_access.json
}

resource "aws_iam_policy_attachment" "donald_lambda" {
  name       = "${var.prefix}-donald-lambda"
  roles      = [aws_iam_role.donald_lambda.name]
  policy_arn = aws_iam_policy.donald_lambda.arn
}
