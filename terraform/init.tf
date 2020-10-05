provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

locals {
  aws_az = data.aws_availability_zones.all.names

  private_key  = tls_private_key.cockroach.private_key_pem
  public_key   = tls_private_key.cockroach.public_key_openssh
  cluster_name = "crdb-cluster-${random_uuid.cluster_id.result}"

  aws_tags = merge({
    environment = var.environment
    version     = var.module_version
    cluster_id  = random_uuid.cluster_id.result
    owner       = var.owner
    Name        = "${var.owner}-${local.cluster_name}"
  }, var.user_tags)
}

resource "random_uuid" "cluster_id" {}

resource "tls_private_key" "cockroach" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "login" {
  key_name   = "cluster-support-${random_uuid.cluster_id.result}"
  public_key = local.public_key
}
