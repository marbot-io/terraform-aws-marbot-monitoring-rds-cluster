##########################################################################
#                                                                        #
#                                 EVENTS                                 #
#                                                                        #
##########################################################################

resource "aws_db_event_subscription" "rds_cluster_issue" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? 1 : 0

  sns_topic   = join("", aws_sns_topic.marbot.*.arn)
  source_type = "db-cluster"
  # source_ids  = [var.db_cluster_identifier]
  #! I am commenting above argument ^^ As I want to get events from all RDS instances and clusters.
  tags = var.tags
}

resource "aws_db_event_subscription" "rds_instance_issue" {
  depends_on = [aws_sns_topic_subscription.marbot]
  count      = var.enabled ? 1 : 0

  sns_topic   = join("", aws_sns_topic.marbot.*.arn)
  source_type = "db-instance"
  # source_ids  = [var.db_cluster_identifier]
  #! I am commenting above argument ^^ As I want to get events from all RDS instances and clusters.
  tags = var.tags
}
