terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws    = ">= 2.48.0"
    random = ">= 2.2"
  }
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_rds_cluster" "cluster" {
  cluster_identifier = var.db_cluster_identifier
}

locals {
  topic_arn = var.create_topic == false ? var.topic_arn : join("", aws_sns_topic.marbot.*.arn)
  enabled   = var.enabled && lookup(data.aws_rds_cluster.cluster.tags, "marbot", "on") != "off"

  cpu_utilization                        = lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-utilization", var.cpu_utilization)
  cpu_utilization_threshold              = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-utilization:threshold", var.cpu_utilization_threshold)), var.cpu_utilization_threshold)
  cpu_utilization_period_raw             = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-utilization:period", var.cpu_utilization_period)), var.cpu_utilization_period)
  cpu_utilization_period                 = min(max(floor(local.cpu_utilization_period_raw / 60) * 60, 60), 86400)
  cpu_utilization_evaluation_periods_raw = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-utilization:evaluation-periods", var.cpu_utilization_evaluation_periods)), var.cpu_utilization_evaluation_periods)
  cpu_utilization_evaluation_periods     = min(max(local.cpu_utilization_evaluation_periods_raw, 1), floor(86400 / local.cpu_utilization_period))

  cpu_credit_balance                        = lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-credit-balance", var.cpu_credit_balance)
  cpu_credit_balance_threshold              = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-credit-balance:threshold", var.cpu_credit_balance_threshold)), var.cpu_credit_balance_threshold)
  cpu_credit_balance_period_raw             = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-credit-balance:period", var.cpu_credit_balance_period)), var.cpu_credit_balance_period)
  cpu_credit_balance_period                 = min(max(floor(local.cpu_credit_balance_period_raw / 60) * 60, 60), 86400)
  cpu_credit_balance_evaluation_periods_raw = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:cpu-credit-balance:evaluation-periods", var.cpu_credit_balance_evaluation_periods)), var.cpu_credit_balance_evaluation_periods)
  cpu_credit_balance_evaluation_periods     = min(max(local.cpu_credit_balance_evaluation_periods_raw, 1), floor(86400 / local.cpu_credit_balance_period))

  freeable_memory                        = lookup(data.aws_rds_cluster.cluster.tags, "marbot:freeable-memory", var.freeable_memory)
  freeable_memory_threshold              = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:freeable-memory:threshold", var.freeable_memory_threshold)), var.freeable_memory_threshold)
  freeable_memory_period_raw             = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:freeable-memory:period", var.freeable_memory_period)), var.freeable_memory_period)
  freeable_memory_period                 = min(max(floor(local.freeable_memory_period_raw / 60) * 60, 60), 86400)
  freeable_memory_evaluation_periods_raw = try(tonumber(lookup(data.aws_rds_cluster.cluster.tags, "marbot:freeable-memory:evaluation-periods", var.freeable_memory_evaluation_periods)), var.freeable_memory_evaluation_periods)
  freeable_memory_evaluation_periods     = min(max(local.freeable_memory_evaluation_periods_raw, 1), floor(86400 / local.freeable_memory_period))
}

##########################################################################
#                                                                        #
#                                 TOPIC                                  #
#                                                                        #
##########################################################################

resource "aws_sns_topic" "marbot" {
  count = (var.create_topic && var.enabled) ? 1 : 0

  name_prefix = "marbot"
  tags        = var.tags
}

resource "aws_sns_topic_policy" "marbot" {
  count = (var.create_topic && var.enabled) ? 1 : 0

  arn    = join("", aws_sns_topic.marbot.*.arn)
  policy = data.aws_iam_policy_document.topic_policy.json
}

data "aws_iam_policy_document" "topic_policy" {
  statement {
    sid       = "Sid1"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [join("", aws_sns_topic.marbot.*.arn)]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "rds.amazonaws.com",
      ]
    }
  }

  statement {
    sid       = "Sid2"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [join("", aws_sns_topic.marbot.*.arn)]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_subscription" "marbot" {
  depends_on = [aws_sns_topic_policy.marbot]
  count      = (var.create_topic && local.enabled) ? 1 : 0

  topic_arn              = join("", aws_sns_topic.marbot.*.arn)
  protocol               = "https"
  endpoint               = "https://api.marbot.io/${var.stage}/endpoint/${var.endpoint_id}"
  endpoint_auto_confirms = true
  delivery_policy        = <<JSON
{
  "healthyRetryPolicy": {
    "minDelayTarget": 1,
    "maxDelayTarget": 60,
    "numRetries": 100,
    "numNoDelayRetries": 0,
    "backoffFunction": "exponential"
  },
  "throttlePolicy": {
    "maxReceivesPerSecond": 1
  }
}
JSON
}



resource "aws_cloudwatch_event_rule" "monitoring_jump_start_connection" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.module_version_monitoring_enabled && local.enabled) ? 1 : 0

  name                = "marbot-rds-cluster-connection-${random_id.id8.hex}"
  description         = "Monitoring Jump Start connection. (created by marbot)"
  schedule_expression = "rate(30 days)"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "monitoring_jump_start_connection" {
  count = (var.module_version_monitoring_enabled && local.enabled) ? 1 : 0

  rule      = join("", aws_cloudwatch_event_rule.monitoring_jump_start_connection.*.name)
  target_id = "marbot"
  arn       = local.topic_arn
  input     = <<JSON
{
  "Type": "monitoring-jump-start-tf-connection",
  "Module": "rds-cluster",
  "Version": "1.0.0",
  "Partition": "${data.aws_partition.current.partition}",
  "AccountId": "${data.aws_caller_identity.current.account_id}",
  "Region": "${data.aws_region.current.name}"
}
JSON
}

##########################################################################
#                                                                        #
#                                 ALARMS                                 #
#                                                                        #
##########################################################################

resource "random_id" "id8" {
  byte_length = 8
}



resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (local.cpu_utilization == "static" && local.enabled) ? 1 : 0

  alarm_name          = "marbot-rds-cluster-cpu-utilization-${random_id.id8.hex}"
  alarm_description   = "Average database CPU utilization too high. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = local.cpu_utilization_period
  evaluation_periods  = local.cpu_utilization_evaluation_periods
  comparison_operator = "GreaterThanThreshold"
  threshold           = local.cpu_utilization_threshold
  alarm_actions       = [local.topic_arn]
  ok_actions          = [local.topic_arn]
  dimensions = {
    DBClusterIdentifier = var.db_cluster_identifier
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}



resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (local.cpu_credit_balance == "static" && local.enabled) ? 1 : 0

  alarm_name          = "marbot-rds-cluster-cpu-credit-balance-${random_id.id8.hex}"
  alarm_description   = "Average database CPU credit balance too low, expect a significant performance drop soon. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUCreditBalance"
  statistic           = "Average"
  period              = local.cpu_credit_balance_period
  evaluation_periods  = local.cpu_credit_balance_evaluation_periods
  comparison_operator = "LessThanThreshold"
  threshold           = local.cpu_credit_balance_threshold
  alarm_actions       = [local.topic_arn]
  ok_actions          = [local.topic_arn]
  dimensions = {
    DBClusterIdentifier = var.db_cluster_identifier
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}



resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (local.freeable_memory == "static" && local.enabled) ? 1 : 0

  alarm_name          = "marbot-rds-cluster-freeable-memory-${random_id.id8.hex}"
  alarm_description   = "Average database freeable memory too low, performance may suffer. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "FreeableMemory"
  statistic           = "Average"
  period              = local.freeable_memory_period
  evaluation_periods  = local.freeable_memory_evaluation_periods
  comparison_operator = "LessThanThreshold"
  threshold           = local.freeable_memory_threshold
  alarm_actions       = [local.topic_arn]
  ok_actions          = [local.topic_arn]
  dimensions = {
    DBClusterIdentifier = var.db_cluster_identifier
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}

##########################################################################
#                                                                        #
#                                 EVENTS                                 #
#                                                                        #
##########################################################################

resource "aws_db_event_subscription" "rds_cluster_issue" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = local.enabled ? 1 : 0

  name_prefix = "marbot"
  sns_topic   = local.topic_arn
  source_type = "db-cluster"
  source_ids  = [var.db_cluster_identifier]
  tags        = var.tags
}
