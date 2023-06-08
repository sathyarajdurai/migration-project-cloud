resource "aws_secretsmanager_secret" "vpc_secret" {
  # checkov:skip=BC_AWS_GENERAL_79: ADD REASON by default encryption
  name = "myaddress"
}

resource "aws_secretsmanager_secret_version" "vpc_string" {
    secret_id     = aws_secretsmanager_secret.vpc_secret.id
    secret_string = <<EOF
   {
                "rdspassword": "${local.rdspass}",
                "myaddress1": "${local.myadd}",
                "vpc_cidr": "10.0.0.0/16" 
    }
EOF
}