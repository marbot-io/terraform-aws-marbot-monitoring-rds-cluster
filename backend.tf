# make sure to replace the value with your own values.
# make sure your S3 bucket and DynamoDB table exists

#! You can refer to this terraform file to learn more about how to create S3 bucket and DynamoDB table for terraform remote backend
terraform {
  backend "s3" {
    bucket         = "terraform-storage-bucket-170545349006"
    key            = "marbot-for-rds"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-dynamodb-table"
  }
}
