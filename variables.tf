variable "env" {
  description = "Unique name of your Terraform environment to be used for naming resources"
  default     = "default"
}

variable "tags" {
  description = "Additional tags to be applied to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where the security group and routes will be created"
  default     = ""
}

variable "vpc_route_tables" {
  description = "All route tables that you want to receive the peering route"
  default     = []
}

variable "peer_env" {
  description = "Environment of the VPC you are peering with"
  default     = ""
}

variable "vpc_peering_connection_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/vpc_peering_accepter.html#vpc_peering_connection_id"
  default     = ""
}

variable "peer_vpc_cidr_block" {
  description = "CIDR block associated with the peer VPC"
  default     = ""
}

variable "create" {
  description = "Controls if all resources should be created or not."
  default     = true
}
