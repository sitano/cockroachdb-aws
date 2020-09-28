resource "tls_private_key" "cockroach" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "login" {
  key_name   = "cluster-support-${random_uuid.cluster_id.result}"
  public_key = local.public_key
}

resource "aws_instance" "cockroach" {
  ami               = var.database_ami
  instance_type     = var.aws_instance_type
  key_name          = aws_key_pair.login.key_name
  monitoring        = true
  availability_zone = element(local.aws_az, count.index % length(local.aws_az))
  subnet_id         = element(aws_subnet.subnet.*.id, count.index)
  user_data         = ""

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
    aws_security_group.user.id
  ]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags  = merge(local.aws_tags, map("type", "cockroach"))
  count = var.nodes_count
}

resource "aws_instance" "loader" {
  ami               = var.loaders_ami
  instance_type     = var.loaders_instance_type
  key_name          = aws_key_pair.login.key_name
  monitoring        = true
  availability_zone = element(local.aws_az, count.index % length(local.aws_az))
  subnet_id         = element(aws_subnet.subnet.*.id, count.index)
  user_data         = ""

  vpc_security_group_ids = [
    aws_security_group.cluster.id,
    aws_security_group.user.id
  ]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags  = merge(local.aws_tags, map("type", "cockroach-loader"))
  count = var.loaders
}

resource "aws_eip" "cockroach" {
  vpc      = true
  instance = element(aws_instance.cockroach.*.id, count.index)

  tags = merge(local.aws_tags, map("type", "cockroach"))

  count      = var.nodes_count
  depends_on = [aws_internet_gateway.vpc_igw]
}

resource "aws_eip" "loader" {
  vpc      = true
  instance = element(aws_instance.loader.*.id, count.index)

  tags = merge(local.aws_tags, map("type", "cockroach-loader"))

  count      = var.loaders
  depends_on = [aws_internet_gateway.vpc_igw]
}
