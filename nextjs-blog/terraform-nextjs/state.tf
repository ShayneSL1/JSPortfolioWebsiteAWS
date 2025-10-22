terraform {
    backend "s3"{
        bucket = "webPortfolio-terraform-state"
        key = "global/s3/backend-terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "s3-terraform-table"
    }
}