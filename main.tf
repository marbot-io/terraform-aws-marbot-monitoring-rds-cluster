##########################################################################
#                                                                        #
#                                 ALARMS                                 #
#                                                                        #
##########################################################################

resource "random_id" "id8" {
  byte_length = 8
}


###! Alarms for DB Clusters

resource "aws_cloudwatch_metric_alarm" "cluster_cpu_utilization" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.cpu_utilization_threshold >= 0 && var.enabled) ? length(var.db_clusters_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_clusters_identifier_list, count.index)}-rds-cluster-cpu-utilization"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_utilization_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBClusterIdentifier = element(var.db_clusters_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cluster_cpu_credit_balance" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.cpu_credit_balance_threshold >= 0 && var.burst_monitoring_enabled && var.enabled) ? length(var.db_clusters_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-cluster-cpu-credit-balance"
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUCreditBalance"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = var.cpu_credit_balance_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBClusterIdentifier = element(var.db_clusters_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cluster_freeable_memory" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.freeable_memory_threshold >= 0 && var.enabled) ? length(var.db_clusters_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-cluster-freeable-memory"
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "FreeableMemory"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = var.freeable_memory_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBClusterIdentifier = element(var.db_clusters_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}


###! Alarms for standalone DB instances
resource "aws_cloudwatch_metric_alarm" "instances_cpu_utilization" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.cpu_utilization_threshold >= 0 && var.enabled) ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-cpu-utilization"
  alarm_description   = "Average database CPU utilization over last 10 minutes too high. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_utilization_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBInstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}


resource "aws_cloudwatch_metric_alarm" "instance_cpu_credit_balance" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.cpu_credit_balance_threshold >= 0 && var.burst_monitoring_enabled && var.enabled) ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-cpu-credit-balance"
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "CPUCreditBalance"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = var.cpu_credit_balance_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBInstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}



resource "aws_cloudwatch_metric_alarm" "instance_freeable_memory" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = (var.freeable_memory_threshold >= 0 && var.enabled) ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-freeable_memory"
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer. (created by marbot)"
  namespace           = "AWS/RDS"
  metric_name         = "FreeableMemory"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = var.freeable_memory_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBInstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}

