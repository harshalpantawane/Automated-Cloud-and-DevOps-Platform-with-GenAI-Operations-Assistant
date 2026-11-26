variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
}
variable "env_name" {
  description = "project and env name"
  type        = string
}
variable "public_subnet_count" {
  description = "Public Subnet Number"
  type = number
}
variable "private_subnet_count" {
  description = "Private Subnet Number"
  type = number
}
