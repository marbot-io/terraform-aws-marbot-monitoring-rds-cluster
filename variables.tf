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
  default     = 100
}

variable "freeable_memory_threshold" {
  type        = number
  description = "The minimum amount of available random access memory in Byte (set to -1 to disable)."
  default     = 2000000000 # 2 GBs in Byte
}

variable "read_latency_threshold" {
  type        = number
  description = "The maximum amount of latency to allow for data read"
  default     = 0.004 # 2 ms in seconds
}

variable "write_latency_threshold" {
  type        = number
  description = "The maximum amount of latency to allow for data write"
  default     = 0.004 # 3 ms in seconds
}

variable "available_storage_threshold" {
  type        = number
  description = "The minimum amount of available storage in Byte."
  default     = 10000000000 # 10 GBs in Byte
}

variable "aurora_replication_lag_maximum" {
  type        = number
  description = "The maximum amount of lag in milliseconds between the primary instance and each Aurora DB instance in the DB cluster." # for Cluster
  default     = 500
}

variable "aurora_replication_lag" {
  type        = number
  description = "For an Aurora replica, the in milliseconds amount of lag when replicating updates from the primary instance."
  default     = 500
}

variable "cluster_db_connection_count" {
  type        = number
  description = "The number of client network connections to the database cluster."
  default     = 350
}

variable "instance_db_connection_count" {
  type        = number
  description = "The number of client network connections to the database instance."
  default     = 350
}

#! Extra
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
