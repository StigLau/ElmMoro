provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "stigs"
}

data "aws_s3_bucket" "kompostapp" {
  bucket = "app.kompo.st"
}
