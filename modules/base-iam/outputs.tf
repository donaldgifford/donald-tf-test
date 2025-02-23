#--------------------------------------------------------------
# lambda output variables
#--------------------------------------------------------------
output "lambda_iam_role_arn" {
  value = module.base_iam.lambda_iam_role_arn
}
