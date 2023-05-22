# resource "aws_route53_zone" "public_common" {
#   name = "capci-gp4.aws.crlabs.cloud"
# }



resource "aws_route53_zone" "public_member" {
  name = "capci-gp4.aws.crlabs.cloud"


  tags = {
    Environment = "dev"
  }
}

resource "aws_route53_record" "resolve_test" {
  zone_id = aws_route53_zone.public_member.zone_id
  name    = "capci-gp4.aws.crlabs.cloud"
  type    = "A"
  ttl     = "30"
  records = [jsondecode(data.aws_secretsmanager_secret_version.my_ip.secret_string).myaddress]
}