resource "aws_lb" "crdb_lb" {
  name               = "crdblb"
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true

  subnets = aws_subnet.subnet.*.id

  tags = local.aws_tags
}

resource "aws_lb_target_group" "crdb_lb_tg" {
  name     = "crdblbtg"

  port     = var.lb_target_port
  protocol = "TCP"

  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/health?ready=1"
    protocol            = "HTTP"
    port                = 8080
    interval            = 30
  }

  tags = local.aws_tags
}

resource "aws_lb_target_group_attachment" "crdb_lb_tg_at" {
  target_group_arn = aws_lb_target_group.crdb_lb_tg.arn
  target_id        = aws_instance.cockroach[count.index].id
  port             = var.lb_target_port

  count = var.nodes
}