#--------------------------------------------------------------
# Shared Variables
#--------------------------------------------------------------
variable "region" {
  description = "AWS Region Used"
  type        = string
}

variable "prefix" {
  description = "Prefix variable for naming convention"
  type        = string
}

variable "delimiter" {
  default     = "-"
  description = "Delimiter for tags"
  type        = string
}

variable "bucket_name" {
  default     = "bucket"
  description = "Bucket Name"
  type        = string
}

variable "aws_profile" {
  default     = ""
  description = "aws profile to use in provider"
  type        = string
}

#--------------------------------------------------------------
# Provider definitions
#--------------------------------------------------------------
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

