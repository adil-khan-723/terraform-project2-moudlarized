terraform {
  backend "s3" {
    bucket         = "oggy-backend-bucket"
    key            = "project2-modularized/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "stateLock-table"
    encrypt        = true
  }
}