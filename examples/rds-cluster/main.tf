terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.48.0"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "example" {
  subnet_ids = slice(data.aws_subnets.default.ids, 0, 3)
}

resource "aws_rds_cluster" "example" {
  db_subnet_group_name = aws_db_subnet_group.example.name
  engine               = "aurora-mysql"
  engine_version       = "8.0.mysql_aurora.3.03.0"
  engine_mode          = "provisioned"
  database_name        = "example"
  master_username      = "example"
  master_password      = "supersecret"
  skip_final_snapshot  = true
}
