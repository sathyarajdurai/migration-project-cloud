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