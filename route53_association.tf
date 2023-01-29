module "tazo_splunk_route53_assoc" {
  enabled = local.is_prod ? 0 : 1
  source  = "git::https://gitlab.tooling-prod.ice.mod.gov.uk/burgundy/ice/shared-modules/terraform-aws-modules/terraform-aws-resource-modules/terraform-aws-r53-vpc-association"
  project = var.project
  zone_id = aws_route53_zone.hosted_zone_prv.zone_id
  vpc_id  = data.aws_vpc.prod.id
  region  = var.region

  AWS_ACCESS_KEY_ID_VPC     = var.AWS_ACCESS_KEY_ID_TRAZO
  AWS_SECRET_ACCESS_KEY_VPC = var.AWS_SECRET_ACCESS_KEY_TRAZO
  AWS_SESSION_TOKEN_VPC     = var.AWS_SESSION_TOKEN_TRAZO
}
