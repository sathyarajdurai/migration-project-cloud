resource "aws_secretsmanager_secret" "rds_secret_new" {
  # checkov:skip=BC_AWS_GENERAL_79: ADD REASON by default encryption
  name = "rds-secret-new"
}

resource "aws_secretsmanager_secret_version" "example" {
    secret_id     = aws_secretsmanager_secret.rds_secret_new.id
    secret_string = <<EOF
   {
                "username": "${local.name}", 
                "password": "${local.pass}", 
                "port": "${local.port}", 
                "host": "${local.host}"
   }
EOF

}



