# RDS cluster monitoring

Connects you to RDS Event Notifications of a particular RDS cluster, adds alarms for CPU and memory, and forwards them to Slack managed by [marbot](https://marbot.io/).

## Usage

1. Create a new directory
2. Within the new directory, create a file `main.tf` with the following content:
```
provider "aws" {}

module "marbot-monitoring-rds-cluster" {
  source   = "marbot-io/marbot-monitoring-rds-cluster/aws"
  #version = "x.y.z"

  endpoint_id           = "" # to get this value: select a Slack channel where marbot belongs to and send a message like this: "@marbot show me my endpoint id"
  db_cluster_identifier = "" # the cluster identifier
}
```
3. Run the following commands:
```
terraform init
terraform apply
```
