locals {
  ### Set path
  path = path_relative_to_include()

  ### Set region
  # region = basename(dirname(get_terragrunt_dir()))
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "prod-donald-demo-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "prod-donald-demo-tfstate"
    profile        = "prod-donald-demo"
  }
}

inputs = {
  aws_region                   = "us-east-2"
  tfstate_global_bucket        = "prod-donald-demo-tfstate"
  tfstate_global_bucket_region = "us-east-2"
  aws_profile                  = "prod-donald-demo"
}
