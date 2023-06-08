

# output "aws_secretsmanager_secret"{
#     value = [jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string).myaddress]
#     sensitive = true
# }