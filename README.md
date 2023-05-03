# RDS cluster monitoring

Connects you to RDS Event Notifications of a particular RDS cluster, adds alarms to monitor CPU and memory, and forwards them to Slack or Microsoft Teams managed by [marbot](https://marbot.io/).

## Usage

1. Create a new directory
2. Within the new directory, create a file `main.tf` with the following content:
```
provider "aws" {}

module "marbot-monitoring-rds-cluster" {
  source   = "marbot-io/marbot-monitoring-rds-cluster/aws"
  #version = "x.y.z"         # we recommend to pin the version

  endpoint_id           = "" # to get this value, select a channel where marbot belongs to and send a message like this: "@marbot show me my endpoint id"
  db_cluster_identifier = "" # the cluster identifier
}
```
3. Run the following commands:
```
terraform init
terraform apply
```

## Config via tags

You can also configure this module by tagging the RDS cluster (requires v1.0.0 or higher). Tags take precedence over variables (tags override variables).

| tag key                                        | default value                                    | allowed values                                |
| ---------------------------------------------- | ------------------------------------------------ | ----------------------------------------------|
| `marbot`                                       | on                                               | on|off                                        |
| `marbot:cpu-utilization`                       | variable `cpu_utilization`                       | static|off                                    |
| `marbot:cpu-utilization:threshold`             | variable `cpu_utilization_threshold`             | 0-100                                         |
| `marbot:cpu-utilization:period`                | variable `cpu_utilization_period`                | <= 86400 and multiple of 60                   |
| `marbot:cpu-utilization:evaluation-periods`    | variable `cpu_utilization_evaluation_periods`    | >= 1 and $period*$evaluation-periods <= 86400 |
| `marbot:cpu-credit-balance`                    | variable `cpu_credit_balance`                    | static|off                                    |
| `marbot:cpu-credit-balance:threshold`          | variable `cpu_credit_balance_threshold`          | >= 0                                          |
| `marbot:cpu-credit-balance:period`             | variable `cpu_credit_balance_period`             | <= 86400 and multiple of 60                   |
| `marbot:cpu-credit-balance:evaluation-periods` | variable `cpu_credit_balance_evaluation_periods` | >= 1 and $period*$evaluation-periods <= 86400 |
| `marbot:freeable-memory`                       | variable `freeable_memory`                       | static|off                                    |
| `marbot:freeable-memory:threshold`             | variable `freeable_memory_threshold`             | >= 0                                          |
| `marbot:freeable-memory:period`                | variable `freeable_memory_period`                | <= 86400 and multiple of 60                   |
| `marbot:freeable-memory:evaluation-periods`    | variable `freeable_memory_evaluation_periods`    | >= 1 and $period*$evaluation-periods <= 86400 |

## Update procedure

1. Update the `version`
2. Run the following commands:
```
terraform get
terraform apply
```

## License
All modules are published under Apache License Version 2.0.

## About
A [marbot.io](https://marbot.io/) project. Engineered by [widdix](https://widdix.net).
