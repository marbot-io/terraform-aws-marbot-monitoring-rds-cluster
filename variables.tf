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

variable "stage" {
  type        = string
  description = "marbot stage (never change this!)."
  default     = "v1"
}

variable "deployment-type" {
  type        = string
  description = "Specify whether this is an db-cluster or an db-instance"
  default     = "db-cluster"
}

locals {
  db-type = {
    db-cluster = {
      DBClusterIdentifier = var.db_cluster_identifier
    },
    db-instance = {
      DBInstanceIdentifier = var.db_cluster_identifier
    }
  }
} 