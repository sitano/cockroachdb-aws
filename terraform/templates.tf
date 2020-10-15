data "aws_availability_zones" "all" {}

data "template_file" "cockroach_cidr" {
  template = "$${cidr}"

  vars = {
    cidr = "${var.cluster_broadcast == "private" ? element(aws_instance.cockroach.*.private_ip, count.index) : element(aws_eip.cockroach.*.public_ip, count.index)}/32"
  }

  count = var.nodes
}
