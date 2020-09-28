output "cluster_id" {
  value = random_uuid.cluster_id.result
}

output "seeds" {
  value = aws_eip.cockroach.*.public_ip
}

output "private_key" {
  value = local.private_key
}

output "public_key" {
  value = local.public_key
}

output "elb_dns_name" {
  value = aws_lb.crdb_lb.dns_name
}