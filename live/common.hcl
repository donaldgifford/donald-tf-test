# Common variables for all AWS accounts.
locals {
  # ----------------------------------------------------------------------------------------------------------------
  # ACCOUNT IDS AND CONVENIENCE LOCALS
  # ----------------------------------------------------------------------------------------------------------------

  # Centrally define all the AWS account IDs. We use JSON so that it can be readily parsed outside of Terraform.
  account_ids = jsondecode(file("accounts.json"))

  # Define a default region to use when operating on resources that are not contained within a specific region.
  default_region = "us-east-1"

  # A prefix used for naming resources.
  name_prefix = "poop"
}
