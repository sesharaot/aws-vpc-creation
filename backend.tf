terraform {
  backend "s3" {
    bucket         = "ninjacart-jars"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    #dynamodb_table = "<your_dynamo_dbtable_name>"
  }
}