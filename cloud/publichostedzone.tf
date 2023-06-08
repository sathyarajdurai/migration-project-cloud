# resource "aws_route53_zone" "public_common" {
#   name = "capci-gp4.aws.crlabs.cloud"
# }

resource "aws_route53_zone" "public_member" {
  name = "capci-gp4.aws.crlabs.cloud"


  tags = {
    Environment = "dev"
  }
}

# resource "aws_route53_record" "dev-ns" {
#   zone_id = aws_route53_zone.public_common.zone_id
#   name    = "capci-gp4.aws.crlabs.cloud"
#   type    = "NS"
#   ttl     = "30"
#   records = aws_route53_zone.public_member.name_servers
# }

resource "aws_route53_record" "alb_r53" {
  # checkov:skip=BC_AWS_GENERAL_95: ADD REASON bcoz of my ip
  zone_id = aws_route53_zone.public_member.zone_id
  name    = "resolve-test.capci-gp4.aws.crlabs.cloud"
  type    = "A"
  ttl     = 300
  records = [element(split("/",jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["myaddress1"]),0)]
}

