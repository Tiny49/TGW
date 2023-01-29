# set region and provider versions
provider "aws" {
  region = var.region
}

# create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name    = join("-", ["ice", var.project, terraform.workspace, "vpc"])
    Owner   = var.owner
    Project = join("-", ["ice", var.project, terraform.workspace])
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }

}
# module "vpc" {

#   source = "terraform-aws-modules/vpc/aws"

#   cidr   = "10.200.0.0/16"

# }