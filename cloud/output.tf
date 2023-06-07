# output "certificate_arn" {
#     value = [aws_acm_certificate.mig_cert.arn] 
# }

# output "public_subnets" {

#     value = [module.vpc.public_subnets]

# }

# output "aws_security_group"{
#     value = [aws_security_group.internet_face.id]
# }

# output "aws_secretsmanager_secret"{
#     value = [jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string).myaddress]
#     sensitive = true
# }

output "volume_id" {
    value = data.aws_ebs_volume.test.id
}