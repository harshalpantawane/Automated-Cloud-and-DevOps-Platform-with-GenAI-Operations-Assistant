variable "env_name" {
  description = "env for eks"
  type = string
}

variable "cluster_name" {
  description = "cluster name"
  type = string
}

variable "kubernetes_version" {
  description = "kubernetes version"
  type = string
}
variable "private_subnet_ids" {
  description = "subnet for node"
  type = list(string)
}

variable "node_instance_type" {
  description = "instance type for node"
  type = string
}

variable "node_desired_size" {
  description = "desired no of node"
  type = number
}

variable "node_min_size" {
  description = "min no. of nodes"
  type = number
}

variable "node_max_size" {
  description = "max no. of node size"
  type = number
}