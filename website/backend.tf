terraform {
  backend "s3" {
    bucket = "vireshops.online"
    region = "us-east-1"
    key = "website.tfstate"
  }
}