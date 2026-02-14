# This is where the resources are defined.

provider "aws" {
    region = "us-west-1"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
