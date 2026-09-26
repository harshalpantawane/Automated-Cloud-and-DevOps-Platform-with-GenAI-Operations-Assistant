variable "env_name" {
  type = string
  description = "Env name"
}

variable "comment" {
  type = string
  description = "App"
}

variable "alb_dns_name" {
  type = string
  description = "ALB dns Endpoint"
}

variable "origin_id" {
  type = string
  description = "Origin id"
}

variable "default_behavior_allowed_methods" {
  type = list(string)
  description = "Default behaviour allow methods"
}

variable "default_behavior_cached_methods" {
  type = list(string)
  description = "value"
}

variable "default_behavior_forwarded_values_header" {
  type = list(string)
  description = "default behavior forwarded value headerd"
}