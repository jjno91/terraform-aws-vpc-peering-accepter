resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = "${var.vpc_peering_connection_id}"
  tags          = "${merge(map("Name", "${var.env}-peer-${var.peer_env}"), map("Type", "Accepter"), var.tags)}"
}

resource "aws_route" "this" {
  count                     = "${length(var.vpc_route_tables)}"
  route_table_id            = "${element(var.vpc_route_tables, count.index)}"
  destination_cidr_block    = "${var.peer_vpc_cidr_block}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_id}"
}

resource "aws_security_group" "this" {
  name_prefix = "${var.env}-peer-${var.peer_env}-"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(map("Name", "${var.env}-peer-${var.peer_env}"), map("Type", "Peer"), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  description       = "Ingress peer CIDR"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.this.id}"
  cidr_blocks       = ["${var.peer_vpc_cidr_block}"]
}

resource "aws_security_group_rule" "egress" {
  description       = "Egress peer CIDR"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.this.id}"
  cidr_blocks       = ["${var.peer_vpc_cidr_block}"]
}
