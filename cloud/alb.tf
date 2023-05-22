
resource "aws_lb" "migration_lb" {
  # checkov:skip=BC_AWS_NETWORKING_58: ADD REASON
  depends_on                 = [aws_s3_bucket.elb_logs]
  name                       = "migration-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = module.vpc.public_subnets
  security_groups            = [aws_security_group.internet_face.id]
  enable_deletion_protection = true
  drop_invalid_header_fields = true
  access_logs {
    bucket  = aws_s3_bucket.elb_logs.id
    prefix  = "elblogs"
    enabled = true
  }

}

resource "aws_security_group" "internet_face" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

  }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-all-traffic"
  }
}


resource "time_sleep" "wait_180_seconds" {
  depends_on = [aws_route53_record.lb_validate]

  create_duration = "180s"
}

resource "aws_lb_listener" "front_end" {
  depends_on = [time_sleep.wait_180_seconds]
  load_balancer_arn = aws_lb.migration_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.mig_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

# resource "aws_route53_record" "alb_r53" {
#   zone_id = data.aws_route53_zone.myzone.zone_id
#   name    = "www.capci-gp4.aws.crlabs.cloud"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_lb.migration_lb.dns_name]
# }

resource "aws_route53_record" "aliaslb" {
  zone_id = aws_route53_zone.public_member.zone_id
  name    = "*.capci-gp4.aws.crlabs.cloud"
  type    = "A"

  alias {
    name                   = aws_lb.migration_lb.dns_name
    zone_id                = aws_lb.migration_lb.zone_id
    evaluate_target_health = true
  }
}