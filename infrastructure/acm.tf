module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

	domain_name = "ognjen-dacevic.epsilon.devops.sitesstage.com"

	validation_method = "DNS"

	zone_id = "Z05093533H987FSRQJPN5"

	wait_for_validation = true
}