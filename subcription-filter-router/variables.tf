variable "workload_name" {
  description = "Name of the workload"
  type        = string
  default     = "on-demand_server_router"
}

variable "source_log_group_name" {
  description = "Name of the source log group"
  type        = string
}

variable "filter_pattern" {
  description = "Filter pattern for the log group"
  type        = string
}

variable "service_mapping" {
  description = "Mapping of services"
  type        = map(object({
    cluster = string
    service = string
    region  = string
  }))
}
