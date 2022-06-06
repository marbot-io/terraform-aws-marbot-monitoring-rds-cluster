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
  alarm_description   = "Average database CPU utilization over last 10 minutes too high."
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
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon."
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
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer."
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

#! ---  New ALARMS

resource "aws_cloudwatch_metric_alarm" "cluster_read_latency" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? length(var.db_clusters_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-cluster-read-latency"
  alarm_description   = "The read latency is too high"
  namespace           = "AWS/RDS"
  metric_name         = "ReadLatency"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.read_latency_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBClusterIdentifier = element(var.db_clusters_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}


resource "aws_cloudwatch_metric_alarm" "cluster_write_latency" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? length(var.db_clusters_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-cluster-write-latency"
  alarm_description   = "The write latency is too high"
  namespace           = "AWS/RDS"
  metric_name         = "WriteLatency"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.write_latency_threshold
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
  alarm_description   = "Average database CPU utilization over last 10 minutes too high."
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
  alarm_description   = "Average database CPU credit balance over last 10 minutes too low, expect a significant performance drop soon."
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
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer."
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

#! ---  New ALARMS - Instances

resource "aws_cloudwatch_metric_alarm" "instance_read_latency" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-read-latency"
  alarm_description   = "The read latency is too high"
  namespace           = "AWS/RDS"
  metric_name         = "ReadLatency"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.read_latency_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBinstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}


resource "aws_cloudwatch_metric_alarm" "instance_write_latency" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-write-latency"
  alarm_description   = "The write latency is too high"
  namespace           = "AWS/RDS"
  metric_name         = "WriteLatency"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.write_latency_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBinstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}

resource "aws_cloudwatch_metric_alarm" "instance_available_storage" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? length(var.db_instances_identifier_list) : 0

  alarm_name          = "marbot-${element(var.db_instances_identifier_list, count.index)}-rds-instance-available-storage"
  alarm_description   = "Average database storage is less than 10 GBs over last 10 minutes, Check your instance"
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Average"
  period              = 600
  evaluation_periods  = 1
  comparison_operator = "LessThanThreshold"
  threshold           = var.available_storage_threshold
  alarm_actions       = [join("", aws_sns_topic.marbot.*.arn)]
  ok_actions          = [join("", aws_sns_topic.marbot.*.arn)]
  dimensions = {
    DBInstanceIdentifier = element(var.db_instances_identifier_list, count.index)
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}
