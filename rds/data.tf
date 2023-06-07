

data "aws_vpc" "cloud"{
  filter {
    name = "tag:Name"
    values = ["cloud-migration-vpc"]
  }
}

data "aws_subnet"  "database_subnet" {
    availability_zone = "eu-west-1a"
    filter {
    name   = "tag:Name"
    values = ["database-cloud"]
    }
}

data "aws_subnet"  "database_subnet1" {
    availability_zone = "eu-west-1b"
    filter {
    name   = "tag:Name"
    values = ["database-cloud"]
    }
}


data "aws_instance" "database_server" {
  provider = aws.virgina
  filter {
    name = "tag:Name"
    values = ["database-Server"]
  }
}


data "aws_secretsmanager_secret" "secrets_rds" {
  arn = element(values(element(tolist(aws_db_instance.cloud_db.master_user_secret),0)),1)
}
data "aws_secretsmanager_secret_version" "by_value" {
  secret_id = data.aws_secretsmanager_secret.secrets_rds.id
}

data "aws_secretsmanager_secret" "onprem_db_secret" {
  name = "myaddress"
}

data "aws_secretsmanager_secret_version" "onprem_db_password" {
  secret_id     = data.aws_secretsmanager_secret.onprem_db_secret.id
}