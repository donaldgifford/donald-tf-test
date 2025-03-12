{{- define "inputs" }}
region = "{{ .aws_region }}" 
prefix = "{{ .name_prefix }}"
delimiter = "{{ .S3delimiter }}"
bucket_name = "{{ .S3bucketName }}"
aws_profile = "{{ .S3awsProfile }}"


