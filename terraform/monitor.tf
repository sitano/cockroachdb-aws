resource "aws_instance" "monitor" {
  ami               = var.monitor_ami
  instance_type     = var.monitor_instance_type
  key_name          = aws_key_pair.login.key_name
  monitoring        = true
  availability_zone = element(local.aws_az, count.index % var.azs)
  subnet_id         = element(aws_subnet.subnet.*.id, count.index % var.azs)
  user_data         = ""

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
  ]

  tags  = merge(local.aws_tags, map("type", "cockroach-monitor"))
  count = var.monitor
}

resource "aws_eip" "monitor" {
  vpc      = true
  instance = aws_instance.monitor[count.index].id

  tags = merge(local.aws_tags, map("type", "cockroach-monitor"))

  count      = var.monitor
  depends_on = [aws_internet_gateway.vpc_igw]
}
