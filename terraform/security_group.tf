
resource "aws_security_group" "cluster" {
  name        = "cluster-${random_uuid.cluster_id.result}"
  description = "Security Group for inner cluster connections"
  vpc_id      = aws_vpc.vpc.id

  tags = local.aws_tags
}

resource "aws_security_group_rule" "cluster_egress" {
  type              = "egress"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
}

resource "aws_security_group_rule" "cluster_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks = data.template_file.cockroach_cidr.*.rendered

  from_port = element(var.node_ports, count.index)
  to_port   = element(var.node_ports, count.index)
  protocol  = "tcp"

  count = length(var.node_ports)
}

resource "aws_security_group_rule" "cluster_ingress_for_sg" {
  type                     = "ingress"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = element(var.node_ports, count.index)
  to_port                  = element(var.node_ports, count.index)
  protocol                 = "tcp"

  count = length(var.node_ports)
}

resource "aws_security_group" "user" {
  name        = "cluster-user-${random_uuid.cluster_id.result}"
  description = "Security Group for the user of cluster #${random_uuid.cluster_id.result}"
  vpc_id      = aws_vpc.vpc.id

  tags = local.aws_tags
}

resource "aws_security_group_rule" "user_egress" {
  type              = "egress"
  security_group_id = aws_security_group.user.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "user_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.user.id
  cidr_blocks       = compact(concat(var.cluster_user_cidr))
  from_port         = element(var.user_ports, count.index)
  to_port           = element(var.user_ports, count.index)
  protocol          = "tcp"

  count = length(var.user_ports)
}
