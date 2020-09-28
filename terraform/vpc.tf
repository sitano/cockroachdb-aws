resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = local.aws_tags
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.aws_tags
}

resource "aws_subnet" "subnet" {
  availability_zone       = element(local.aws_az, count.index % length(local.aws_az))
  cidr_block              = format("10.0.%d.0/24", count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = local.aws_tags

  count      = var.nodes_count
  depends_on = [aws_internet_gateway.vpc_igw]
}

resource "aws_eip" "cockroach" {
  vpc      = true
  instance = element(aws_instance.cockroach.*.id, count.index)

  tags = merge(local.aws_tags, map("type", "cockroach"))

  count      = var.nodes_count
  depends_on = [aws_internet_gateway.vpc_igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = local.aws_tags
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)

  count = var.nodes_count
}
