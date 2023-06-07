resource "aws_dms_endpoint" "target" {
  # checkov:skip=BC_AWS_NETWORKING_81: ADD REASON
#   database_name               = "cloud-rds-db"
  endpoint_id                 = "cloud-rds-db"
  endpoint_type               = "target"
  engine_name                 = "mysql"
  ssl_mode                    = "none"
  secrets_manager_access_role_arn = aws_iam_role.secrets_role.arn
  secrets_manager_arn         = aws_secretsmanager_secret.rds_secret_new.arn

  tags = {
    Name = "cloud"
  }
}

resource "aws_iam_role" "secrets_role" {
  name               = "dms-secret-role"
  # path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.secrets_assume_role_policy.json
}

data "aws_iam_policy_document" "secrets_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["dms.eu-west-1.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "secrets_policy" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"]
    resources = [aws_secretsmanager_secret.rds_secret_new.arn]
  }
}

resource "aws_iam_policy" "secrets_create_policy" {
  name        = "secrets-dms-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.secrets_policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.secrets_role.name
  policy_arn = aws_iam_policy.secrets_create_policy.arn
}


resource "aws_dms_endpoint" "source" {
  # checkov:skip=BC_AWS_NETWORKING_81: ADD REASON
  
  endpoint_id                 = "onprem-endpoint"
  endpoint_type               = "source"
  engine_name                 = "mysql"
  port                        = 3306
  password                    = jsondecode(data.aws_secretsmanager_secret_version.onprem_db_password.secret_string).rdspassword
  server_name                 = data.aws_instance.database_server.private_ip
  ssl_mode                    = "none"

  tags = {
    Name = "onprem"
  }

  username = "phpmyadmin"
}