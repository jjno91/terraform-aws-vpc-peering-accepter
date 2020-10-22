variable "env" {
  default = "core-ca-dev"
}

variable "first_cidr" {
  default = "10.100.0.0/16"
}

variable "route_tables" {
  default = ["rtb-123", "rtb-456"]
}

variable "second_cidr" {
  default = "10.101.0.0/16"
}

locals {
  tags = {
    Creator     = "Terraform"
    Environment = var.env
    Owner       = "my-team@my-company.com"
  }
}

module "vpc_peering_accepter" {
  source                    = "github.com/jjno91/terraform-aws-vpc-peering-accepter?ref=master"
  env                       = var.env
  vpc_peering_connection_id = "pcx-123abc"
  vpc_id                    = "my-vpc"
  vpc_route_tables          = [var.route_tables]
  peer_env                  = "core-us-dev"
  peer_vpc_cidr_block       = var.first_cidr
  tags                      = local.tags
}

# if the VPC you are peering with has more than one CIDR associated
# then you will have to create additional routes and security group rules outside of the module
resource "aws_route" "this" {
  count                     = length(var.route_tables)
  route_table_id            = element(var.route_tables, count.index)
  destination_cidr_block    = var.second_cidr
  vpc_peering_connection_id = module.vpc_peering_accepter.vpc_peering_connection_id
}

resource "aws_security_group_rule" "ingress" {
  description       = "Ingress peer CIDR"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.vpc_peering_accepter.security_group_id
  cidr_blocks       = [var.second_cidr]
}

resource "aws_security_group_rule" "egress" {
  description       = "Egress peer CIDR"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.vpc_peering_accepter.security_group_id
  cidr_blocks       = [var.second_cidr]
}

