# Marbot - Made AWS RDS Monitoring and Alerting easy!

Connects you to RDS Event Notifications of a particular RDS cluster or Instance, adds alarms to monitor CPU, CPU Credit Balance and Memory, and forwards them to Slack or Microsoft Teams managed by [marbot](https://marbot.io/).

## How this works :

1. This Will create SNS Topic and It will create a subscription - which is an HTTPS endpoint of Marbot.
2. You will pass the list of DB Instances and Clusters, and this terraform code will create relevant CloudWatch alarms for those RDS resources.
3. So next time any RDS event is generated or any CloudWatch alarm is breached, you will get slack alert.

## Usage :

1. Create a tfvars file in current directory for providing environment variables. example - `production.tfvars`
2. Make sure that you have created the **S3 bucket** and **DynamoDB table** for Terraform Backend - to store state file. The name of resources is mentioned in the `./backend.tf`. Please ensure the names, **region** are correct.
3. Initialize the terraform project with `terraform init` in your current directory.
4. Apply the terraform configuration to provision resources - `terraform apply -var-file production.tfvars`

## Environment Variables :

1. **endpoint_id** = the **Marbot** endpoint ID
   - How to get the endpoint ID : Follow this guide : https://marbot.io/help/setup-marbot.html
2. **db_clusters_identifier_list** : List of all the DB clusters for which you want to create CloudWatch Alarms, example: **["DB-Cluster-1", "DB-Cluster-2", "DB-Cluster-3"]**
3. **db_instances_identifier_list** : List of all the DB Instances for which you want to create CloudWatch Alarms, example: **["DB-Instance-1", "DB-Instance-2", "DB-Instance-3"]**

## License

All modules are published under Apache License Version 2.0.

## About

A [marbot.io](https://marbot.io/) project. Engineered by [widdix](https://widdix.net).
