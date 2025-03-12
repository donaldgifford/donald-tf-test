#--------------------------------------------------------------
# bucket output variables
#--------------------------------------------------------------

output "role_name" {
  value       = aws_iam_role.donald_lambda.name
  description = "Role Name"
}

output "policy_arn" {
  value       = aws_iam_policy.donald_lambda.arn
  description = "Policy ARN"
}

output "policy_json" {
  value       = aws_iam_policy.donald_lambda.policy
  description = "Policy"
}
