#! Important Input Variables
variable "endpoint_id" {
  type        = string
  description = "Your marbot endpoint ID (to get this value: select a channel where marbot belongs to and send a message like this: \"@marbot show me my endpoint id\")."
}

variable "db_clusters_identifier_list" {
  type        = list(string)
  description = "The clusters that you want to monitor."
}

variable "db_instances_identifier_list" {
  type        = list(string)
  description = "The instances that you want to monitor."
}

#! Module related vars
variable "enabled" {
  type        = bool
  description = "Turn the module on or off"
  default     = true
}

variable "stage" {
  type        = string
  description = "marbot stage (never change this!)."
  default     = "v1"
}

#! Threshold values for CloudWatch Alarms

variable "cpu_utilization_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization (set to -1 to disable)."
  default     = 80
}

#? Maybe in future, we may think to remove this variable
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

variable "read_latency_threshold" {
  type        = number
  description = "The maximum amount of latency to allow for data read"
  default     = 0.05 # 50 ms in seconds
}

variable "write_latency_threshold" {
  type        = number
  description = "The maximum amount of latency to allow for data write"
  default     = 0.05 # 50 ms in seconds
}


#! Extra
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
