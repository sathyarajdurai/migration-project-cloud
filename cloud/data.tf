# data "aws_route53_zone" "myzone" {
#   name         = "capci-gp4.aws.crlabs.cloud"
# }

# data "aws_subnet" "public"{
#     filter{
#         name = "tag:Name"
#         values = ["migration-vpc-public-eu-west-1a"]
#     }
# }

# data "aws_subnet" "public1"{
#     filter{
#         name = "tag:Name"
#         values = ["migration-vpc-public-eu-west-1b"]
#     }
# }

data "aws_availability_zones" "available" {

  state = "available"
}

data "aws_instance" "ec2"{
    filter{
        name = "tag:Name"
        values = ["Migrated-webserver-Server"]
    }
}

data "aws_elb_service_account" "main" {}

data "aws_kms_key" "kms_key" {
  key_id = "alias/backendkms"
}

data "aws_secretsmanager_secret" "my_ip" {
  name = "myaddress"
}

data "aws_secretsmanager_secret_version" "by_value" {
  secret_id     = data.aws_secretsmanager_secret.my_ip.id
}

data "aws_ebs_volume" "test" {
  # filter {
  #   name   = "attachment.device"
  #   values = ["/dev/xvdf"]
  # }

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.ec2.id]
  }
}