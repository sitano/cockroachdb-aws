resource "aws_instance" "cockroach" {
  ami               = var.node_ami
  instance_type     = var.node_instance_type
  key_name          = aws_key_pair.login.key_name
  monitoring        = true
  availability_zone = element(local.aws_az, count.index % length(local.aws_az))
  subnet_id         = element(aws_subnet.subnet.*.id, count.index)
  user_data         = ""

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
    aws_security_group.user.id
  ]

  tags  = merge(local.aws_tags, map("type", "cockroach"))
  count = var.nodes_count
}

resource "aws_eip" "cockroach" {
  vpc      = true
  instance = element(aws_instance.cockroach.*.id, count.index)

  tags = merge(local.aws_tags, map("type", "cockroach"))

  count      = var.nodes_count
  depends_on = [aws_internet_gateway.vpc_igw]
}
