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
    Name    = join("-", ["T007B", var.project, "vpc"])
    Owner   = var.owner
    Project = join("-", ["T007B", var.project, "terraform"])
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }

}

# create public routing table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = join(
      "-",
      ["T007B", var.project,"rt-table-pub"],
    )
    Owner   = var.owner
    Project = join("-", ["T007B", var.project, terraform])
  }
}

# create private routing table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = join(
      "-",
      ["T007B", var.project, "rt-table-prv"],
    )
    Owner   = var.owner
    Project = join("-", ["T007B", var.project, terraform])
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# create the internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = join("-", ["TOO7B", var.project,"intgw-pub"])
    Owner   = var.owner
    Project = join("-", ["T007B", var.project, terraform])
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# create a route in the public route table for the internet gateway to get outbound
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# create EIP for the NAT gateway
resource "aws_eip" "nat_ip" {
  vpc = true
}

# create NAT gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.pb0_sub[0].id

  tags = {
    Name    = join("-", ["T007B", var.project, "natgw-pub"])
    Owner   = var.owner
    Project = join("-", ["T007B", var.project, terraform])
  }
}

#create a route in the private route table for the NAT gateway to get outbound
resource "aws_route" "nat_rt" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.terraform_remote_state.tgw_state.outputs.tgw_id
}

# module "vpc" {

#   source = "terraform-aws-modules/vpc/aws"

#   cidr   = "10.200.0.0/16"

# }