provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  profile    = var.aws_profile
}

locals {
  aws_az = data.aws_availability_zones.all.names

  private_key  = ""
  public_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCv5h9eUqER0DgZ9VUoe+fNLdJMV08SHvzqv7tS3g2RDtJm07tF/oeuW5r8LaUYFZTaJQNn/Et+lcuy5epKMcZmr0StPJBHv5zeUl8rA4fTlF+ByyIm3Z4jkjXRrA8yQtV21BawkMjbh5m5gNXBdIHP/54GZn4ZFk3pMISHhQgWltP+44mw540F6exhYwiYfVnarOM+4chUneBMDCCvmfvDQFHCi3KXOLbTEK5a8FJrLxiRrk81m09Nw0dezBIci9ieLsByIkzpH9yAruaejAC2uzpg4r2ht6coKFEoESvlx4l2E6GaHSaYmmJbbmSif9Z+t0So3wjUMKzF4r9fmjV7"
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

# resource "tls_private_key" "cockroach" {
#  algorithm = "RSA"
#  rsa_bits  = "2048"
# }

resource "aws_key_pair" "login" {
  key_name   = "cluster-support-${random_uuid.cluster_id.result}"
  public_key = local.public_key
}
