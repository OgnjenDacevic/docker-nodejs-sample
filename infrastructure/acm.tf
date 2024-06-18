data "aws_route53_zone" "zone" {
  name         = "epsilon.devops.sitesstage.com"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

	domain_name = "ognjen-dacevic.epsilon.devops.sitesstage.com"

	validation_method = "DNS"

	zone_id = data.aws_route53_zone.zone.zone_id

	wait_for_validation = true
}