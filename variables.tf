variable "endpoint_id" {
  type        = string
  description = "Your marbot endpoint ID (to get this value: select a channel where marbot belongs to and send a message like this: \"@marbot show me my endpoint id\")."
}

variable "enabled" {
  type        = bool
  description = "Turn the module on or off"
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "db_cluster_identifier" {
  type        = string
  description = "The cluster identifier of the RDS Aurora cluster that you want to monitor."
}

variable "cpu_utilization_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization (set to -1 to disable)."
  default     = 80
}

variable "burst_monitoring_enabled" {
  type        = bool
  description = "Deprecated, set variable cpu_credit_balance_threshold to -1 instead"
  default     = true
}

variable "cpu_credit_balance_threshold" {
  type        = number
  description = "The minimum number of CPU credits available (t* instances only; set to -1 to disable)."
  default     = 20
}

variable "freeable_memory_threshold" {
  type        = number
  description = "The minimum amount of available random access memory in Byte (set to -1 to disable)."
  default     = 64000000 # 64 Megabyte in Byte
}

# We can not only check the var.topic_arn !="" because of the Terraform error:  The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created.
variable "create_topic" {
  type        = bool
  description = "Create SNS topic? If set to false you must set topic_arn as well!"
  default     = true
}

variable "topic_arn" {
  type        = string
  description = "Optional SNS topic ARN if create_topic := false (usually the output of the modules marbot-monitoring-basic or marbot-standalone-topic)."
  default     = ""
}

variable "stage" {
  type        = string
  description = "marbot stage (never change this!)."
  default     = "v1"
}
