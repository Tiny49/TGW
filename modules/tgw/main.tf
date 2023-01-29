provider "aws" {
  alias      = "tgw"
  access_key = var.AWS_ACCESS_KEY_ID_TGW
  secret_key = var.AWS_SECRET_ACCESS_KEY_TGW
  token      = var.AWS_SESSION_TOKEN_TGW
  region     = var.region
}

locals {
  tgw_state = {
    outbound = "s01.env:/prod/s01.env.outbound/s01.env.transitgatewayprod.TransitGateway_state.tfstate"
  }[var.tgw_environment]
}

data "terraform_remote_state" "tgw_state" {
  backend = "s3"
  config = {
    bucket     = "tf.remote.state"
    key        = local.tgw_state
    region     = "eu-west-2"
    encrypt    = true
    access_key = var.AWS_ACCESS_KEY_ID_TGW
    secret_key = var.AWS_SECRET_ACCESS_KEY_TGW
    token      = var.AWS_SESSION_TOKEN_TGW
  }
}

data "aws_ec2_transit_gateway_route_table" "cust" {
  provider = aws.tgw
  filter {
    name   = "tag:Name"
    values = ["prod-outbound-cust"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [local.tgwid]
  }
}

locals {
  tgwid      = data.terraform_remote_state.tgw_state.outputs.tgw_id
  sharedrtid = data.terraform_remote_state.tgw_state.outputs.shared_transit_rt_id
  custrtid   = data.aws_ec2_transit_gateway_route_table.cust.id
}

resource "aws_ram_principal_association" "transit_principal_association" {
  provider           = aws.tgw
  principal          = data.aws_caller_identity.current.account_id
  resource_share_arn = data.terraform_remote_state.tgw_state.outputs.aws_ram_resource_share_transit_gw_arn
}

resource "aws_ec2_transit_gateway_vpc_attachment" "publishing_transit_attachment" {
  vpc_id                                          = aws_vpc.vpc.id
  transit_gateway_id                              = local.tgwid
  subnet_ids                                      = [element(aws_subnet.pv1_sub.*.id, 0), element(aws_subnet.pv1_sub.*.id, 1)]
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support                          = "enable"

  depends_on = [aws_ram_principal_association.transit_principal_association]

  tags = merge(
    {
      "Name"    = "ice-${var.project}-${terraform.workspace}-tgw-attach"
      "Owner"   = var.owner
      "Project" = join("-", ["ice", var.project, terraform.workspace])
    },
  )

  # Ignore changes to the TGW attachments default route table settings.  These are hardcoded to true in the terraform source code.
  lifecycle {
    ignore_changes = [transit_gateway_default_route_table_association, transit_gateway_default_route_table_propagation]
  }

  provisioner "local-exec" {
    command = <<EOS
AWS_DEFAULT_REGION=${var.region} aws ec2 create-tags \
--resources ${aws_ec2_transit_gateway_vpc_attachment.publishing_transit_attachment.id} \
--tags \
Key=Name,Value=\"ice-${var.project}-${terraform.workspace}-tgw-attach\" \
Key=Owner,Value=\"${var.owner}\" \
Key=Project,Value=\"${join("-", ["ice", var.project, terraform.workspace])}\" \
Key=Purpose,Value=\"Publishing\" \
Key=Environment,Value=\"${terraform.workspace}\"
EOS


    environment = {
      AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID_TGW
      AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY_TGW
      AWS_SESSION_TOKEN     = var.AWS_SESSION_TOKEN_TGW
    }
  }
}

resource "null_resource" "delayagain" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.publishing_transit_attachment]
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

# Propagate this route to the shared service route table
resource "aws_ec2_transit_gateway_route_table_propagation" "shared_rt_propagation" {
  provider                       = aws.tgw
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.publishing_transit_attachment.id
  transit_gateway_route_table_id = local.sharedrtid
}


resource "aws_ec2_transit_gateway_route_table_association" "outbound_attachment_transit_rt_association" {
  provider                       = aws.tgw
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.publishing_transit_attachment.id
  transit_gateway_route_table_id = local.custrtid
  depends_on                     = [null_resource.delayagain]
}

# Add the route to send all traffic back across the transit gateway
resource "aws_route" "transit_rt" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = data.terraform_remote_state.tgw_state.outputs.tgw_id

  depends_on = [aws_ram_principal_association.transit_principal_association]
}

#create a route for VMWare SDDC
resource "aws_route" "sddc_rt" {
  count                  = local.is_prod ? 1 : 0 # only in prod
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.artic_address_range
  transit_gateway_id     = var.artic_tgw_id
  depends_on             = [aws_ram_principal_association.transit_principal_association]
}