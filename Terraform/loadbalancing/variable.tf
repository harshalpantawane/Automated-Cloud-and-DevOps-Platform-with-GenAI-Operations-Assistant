variable "env_name" {
  description = "env name"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
  description = "private subnet ids"
}

variable "vpc_cidr" {
  type = string
  description = "vpc cidr"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "public subnet ids"
}