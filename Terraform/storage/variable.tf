variable "env_name" {
  type = string
  description = "env name"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "private subnet ids"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "rds_sg_ingress_rules" {
  type = map(object({
    description = string
    from_port = number
    to_port   = number
    protocol = string
    cidr_block = list(string)
  }))

  default = {
   
  }
}

variable "vpc_cidr" {
  type = string
  description = "vpc cidr"
}

variable "rds_db_username" {
  type = string
  description = "rds username"
}

variable "rds_db_parameter_name" {
  type = string
  description = "rds parameter name for password"
}