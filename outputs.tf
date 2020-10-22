output "vpc_peering_connection_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/vpc_peering_accepter.html#id"
  value = element(
    concat(aws_vpc_peering_connection_accepter.this.*.id, [""]),
    0,
  )
}

output "accept_status" {
  description = "https://www.terraform.io/docs/providers/aws/r/vpc_peering_accepter.html#accept_status"
  value = element(
    concat(
      aws_vpc_peering_connection_accepter.this.*.accept_status,
      [""],
    ),
    0,
  )
}

output "security_group_id" {
  description = "Security group that grants access to and from the peer's CIDR"
  value       = element(concat(aws_security_group.this.*.id, [""]), 0)
}

