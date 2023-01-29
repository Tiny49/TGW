# public subnet section
# This public subnet serves as NAT gateway for Deep Security Manager deployments

resource "aws_subnet" "pb0_sub" {
  count             = length(local.pb0)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.pb0_az, count.index)
  cidr_block        = element(local.pb0, count.index)

  tags = {
    Name = "${join(
      "-",
      [
        "ice",
        var.project,
        terraform.workspace,
        "subnt",
        var.pb0_name,
      ],
    )}-pub"
    Owner                                                                = var.owner
    Project                                                              = join("-", ["ice", var.project, terraform.workspace])
    "kubernetes.io/role/elb"                                             = "1"
    "kubernetes.io/cluster/${var.project}-${terraform.workspace}-k8s-tl" = "shared"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table_association" "pb_assoc0" {
  count          = length(aws_subnet.pb0_sub.*.id)
  subnet_id      = element(aws_subnet.pb0_sub.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Private subnet section
resource "aws_subnet" "pv0_sub" {
  count             = length(local.pv0)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.pv0_az, count.index)
  cidr_block        = element(local.pv0, count.index)

  tags = {
    Name = "${join(
      "-",
      [
        "ice",
        var.project,
        terraform.workspace,
        "subnt",
        var.pv0_name,
      ],
    )}-prv"
    Owner                                             = var.owner
    Project                                           = join("-", ["ice", var.project, terraform.workspace])
    "kubernetes.io/cluster/ice-tooling-asdttrazo-dev" = "shared"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table_association" "pv_assoc0" {
  count          = length(aws_subnet.pv0_sub.*.id)
  subnet_id      = element(aws_subnet.pv0_sub.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "pv1_sub" {
  count             = length(local.pv1)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.pv1_az, count.index)
  cidr_block        = element(local.pv1, count.index)

  tags = {
    Name = "${join(
      "-",
      [
        "ice",
        var.project,
        terraform.workspace,
        "subnt",
        var.pv1_name,
      ],
    )}-prv"
    Owner                                             = var.owner
    Project                                           = join("-", ["ice", var.project, terraform.workspace])
    "kubernetes.io/cluster/ice-tooling-asdttrazo-dev" = "shared"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table_association" "pv_assoc1" {
  count          = length(aws_subnet.pv1_sub.*.id)
  subnet_id      = element(aws_subnet.pv1_sub.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "pv2_sub" {
  count             = length(local.pv2)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.pv2_az, count.index)
  cidr_block        = element(local.pv2, count.index)

  tags = {
    Name = "${join(
      "-",
      [
        "ice",
        var.project,
        terraform.workspace,
        "subnt",
        var.pv2_name,
      ],
    )}-prv"
    Owner   = var.owner
    Project = join("-", ["ice", var.project, terraform.workspace])
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table_association" "pv_assoc2" {
  count          = length(aws_subnet.pv2_sub.*.id)
  subnet_id      = element(aws_subnet.pv2_sub.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "pv3_sub" {
  count             = length(local.pv3)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.pv3_az, count.index)
  cidr_block        = element(local.pv3, count.index)

  tags = {
    Name = "${join(
      "-",
      [
        "ice",
        var.project,
        terraform.workspace,
        "subnt",
        var.pv3_name,
      ],
    )}-prv"
    Owner                                                                = var.owner
    Project                                                              = join("-", ["ice", var.project, terraform.workspace])
    "kubernetes.io/cluster/${var.project}-${terraform.workspace}-k8s-tl" = "shared"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table_association" "pv_assoc3" {
  count          = length(aws_subnet.pv3_sub.*.id)
  subnet_id      = element(aws_subnet.pv3_sub.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

