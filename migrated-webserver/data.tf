data "aws_ami" "migrated_ami" {
  filter {
    name   = "tag:Name"
    values = ["MGN-AMI"]
  }
}

data "aws_key_pair" "cloud_key" {
  key_name           = "cloud-key"
  include_public_key = true
}

data "aws_security_group" "web_server" {
  filter {
    name   = "tag:Name"
    values = ["web-server-sg"]
  }
}

data "aws_subnet" "public" {
  availability_zone = "eu-west-1a"
  filter {
    name   = "tag:Name"
    values = ["public-cloud"]
  }
}



data "aws_secretsmanager_secret" "secrets_rds" {
  arn = element(values(element(tolist(data.aws_db_instance.rds_db.master_user_secret), 0)), 1)
}
data "aws_secretsmanager_secret_version" "by_value" {
  secret_id = data.aws_secretsmanager_secret.secrets_rds.id
}

data "aws_db_instance" "rds_db" {
  db_instance_identifier = "cloud-rds-db"
}

data "aws_secretsmanager_secret" "db_secret" {
  name = "myaddress"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

# data "aws_iam_role" "ssm_role" {
#   name = "ssm_role"
# }
