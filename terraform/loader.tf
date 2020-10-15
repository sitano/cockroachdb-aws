resource "aws_instance" "loader" {
  ami               = var.loaders_ami
  instance_type     = var.loaders_instance_type
  key_name          = aws_key_pair.login.key_name
  monitoring        = true
  availability_zone = element(local.aws_az, count.index % var.azs)
  subnet_id         = element(aws_subnet.subnet.*.id, count.index % var.azs)
  user_data         = ""

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
    aws_security_group.user.id
  ]

  tags  = merge(local.aws_tags, map("type", "cockroach-loader"))
  count = var.loaders
}

resource "aws_eip" "loader" {
  vpc      = true
  instance = element(aws_instance.loader.*.id, count.index)

  tags = merge(local.aws_tags, map("type", "cockroach-loader"))

  count      = var.loaders
  depends_on = [aws_internet_gateway.vpc_igw]
}
