#--------------------------------------------------------------
# bucket output variables
#--------------------------------------------------------------

output "bucket_id" {
  value       = aws_s3_bucket.bucket.id
  description = "Bucket ID"
}

output "logs_bucket_id" {
  value       = aws_s3_bucket.bucket_logs.id
  description = "S3 Logs Bucket ID"
}
