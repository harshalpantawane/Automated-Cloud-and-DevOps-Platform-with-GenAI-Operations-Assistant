variable "env_name" {
  description = "project and env name"
  type = string
}
variable "vpc_id" {
  type = string
  description = "vpc id for sg"
}
variable "vpc_cidr" {
  type = string
  description = "vpc cidr for sg ingress"
}
variable "instance_type" {
  description = "instance type for ec2"
  type = string
}

variable "subnet_id" {
  description = "value"
  type = string
}
variable "desired_capacity" {
  type = number
  description = "desired capacity"
}
variable "max_size" {
  description = "max size of instance"
  type = number
}
variable "min_size" {
  type = number
  description = "min size id ec2"
}
variable "private_subnet_ids" {
  type = (list(string))
  description = "private subnet ids"
}

variable "nlb_tg_arn" {
  type = string
  description = "tg arn"
}
variable "rds_db_endpoint" {
  type = string
  description = "rds db endpoint"
}
variable "rds_db_uname" {
  type = string
  description = "rds db username"
}

variable "jar_file" {
  type = string
  description = "jar file"
}
variable "rds_db_parameter_name" {
  type = string
  description = "rds db parameter name"
}
