locals {
    name = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["username"]
    pass = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["password"]
    port     = "3306"
    host     = element(split(":",aws_db_instance.cloud_db.endpoint), 0)
}