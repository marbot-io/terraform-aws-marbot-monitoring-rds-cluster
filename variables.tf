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

variable "endpoint_id" {
  type        = string
  description = "Your marbot endpoint ID (to get this value: select a channel where marbot belongs to and send a message like this: \"@marbot show me my endpoint id\")."
}

variable "enabled" {
  type        = bool
  description = "Turn the module on or off"
  default     = true
}

variable "module_version_monitoring_enabled" {
  type        = bool
  description = "Report the module version back to marbot to notify if updates are available."
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



variable "cpu_utilization" {
  type        = string
  description = "CPU utilization (static|off)."
  default     = "static"
}

variable "cpu_utilization_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization (0-100)."
  default     = 80
}

variable "cpu_utilization_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied (<= 86400 and multiple of 60)."
  default     = 600
}

variable "cpu_utilization_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold (>= 1 and $period*$evaluation_periods <= 86400)."
  default     = 1
}




variable "cpu_credit_balance" {
  type        = string
  description = "CPU burst credits for t* instances (static|off)."
  default     = "static"
}

variable "cpu_credit_balance_threshold" {
  type        = number
  description = "The minimum number of CPU credits remaining in the burst bucket (>= 0)."
  default     = 20
}

variable "cpu_credit_balance_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied (<= 86400 and multiple of 60)."
  default     = 600
}

variable "cpu_credit_balance_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold (>= 1 and $period*$evaluation_periods <= 86400)."
  default     = 1
}



variable "freeable_memory" {
  type        = string
  description = "Available memory (static|off)."
  default     = "static"
}

variable "freeable_memory_threshold" {
  type        = number
  description = "The minimum amount of available random access memory in Byte (>= 0)."
  default     = 64000000 # 64 Megabyte in Byte
}

variable "freeable_memory_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied (<= 86400 and multiple of 60)."
  default     = 600
}

variable "freeable_memory_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold (>= 1 and $period*$evaluation_periods <= 86400)."
  default     = 1
}
