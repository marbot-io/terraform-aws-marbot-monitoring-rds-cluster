
resource "aws_cloudwatch_event_rule" "monitoring_jump_start_connection" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? 1 : 0

  name                = "marbot-rds-cluster-connection-${random_id.id8.hex}"
  description         = "Monitoring Jump Start connection. (created by marbot)"
  schedule_expression = "rate(30 days)"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "monitoring_jump_start_connection" {
  count = var.enabled ? 1 : 0

  rule      = join("", aws_cloudwatch_event_rule.monitoring_jump_start_connection.*.name)
  target_id = "marbot"
  arn       = join("", aws_sns_topic.marbot.*.arn)
  input     = <<JSON
{
  "Type": "monitoring-jump-start-tf-connection",
  "Module": "rds-cluster",
  "Version": "0.7.3",
  "Partition": "${data.aws_partition.current.partition}",
  "AccountId": "${data.aws_caller_identity.current.account_id}",
  "Region": "${data.aws_region.current.name}"
}
JSON
}
