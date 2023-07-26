terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.48.0"
    }
  }
}

module "marbot-monitoring-rds-cluster" {
  source = "../../"

  endpoint_id           = var.endpoint_id
  db_cluster_identifier = var.db_cluster_identifier
}