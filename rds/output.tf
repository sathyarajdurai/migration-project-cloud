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

# output "ip" {
#   value = aws_dms_replication_instance.replication_inst.replication_instance_private_ips
  
#   # value = element(tolist(aws_dms_replication_instance.replication_inst.replication_instance_private_ips),0)
# }

output "secret_arn" {
  value = element(values(element(tolist(aws_db_instance.cloud_db.master_user_secret),0)),1)
}