terraform {
  backend "s3" {
    bucket         = "do-assessment3-movie-db-flo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
