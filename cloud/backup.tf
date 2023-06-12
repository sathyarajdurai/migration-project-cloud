
resource "aws_resourcegroups_group" "backup_rg" {
  name = "Migrated-resource-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance",
    "AWS::EC2::Volume"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["Migrated-webserver-Server"]
    },
    {
      "Key": "Name",
      "Values": ["Migrated-volume"]
    }
  ]
}
JSON
  }
}



resource "aws_backup_plan" "webserver_backup" {
  name = "Migrated_webserver"

  rule {
    rule_name         = "Monthly-Backups"
    target_vault_name = aws_backup_vault.migrate_vault.name
    schedule          = "cron(55 11 * * ? *)"
    enable_continuous_backup = true
    start_window = 60
    completion_window = 120
    copy_action {
      destination_vault_arn = aws_backup_vault.migrate_vault.arn
    }

    lifecycle {
      delete_after = 14
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}

resource "aws_backup_vault" "migrate_vault" {
  name        = "MIgrated_backup_vault"
#   kms_key_arn = aws_kms_key.example.arn
}

# resource "aws_backup_region_settings" "test" {
#   resource_type_opt_in_preference = {   
#     "EBS"             = true
#     "EC2"             = true
#     # "RDS"             = true
#   }
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "backup_role" {
  name               = "aws_backups"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "resource_selection_AMI" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "migrated-resource"
  plan_id      = aws_backup_plan.webserver_backup.id
  resources    = [ "*" ]
  # resources = [
  #   data.aws_ebs_volume.test.arn,
  #   data.aws_instance.ec2.arn
  #   ]

  condition {
    string_equals {
      key   = "aws:ResourceTag/Backup"
      value = "AMI-backup"
    }
  }
}

resource "aws_backup_selection" "resource_selection_Volume" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "migrated-resource"
  plan_id      = aws_backup_plan.webserver_backup.id
  resources    = [ "*" ]
  
  condition {
    string_equals {
      key   = "aws:ResourceTag/Name"
      value = "Migrated-volume"
    }
  }
}
