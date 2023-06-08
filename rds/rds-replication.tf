data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

# resource "aws_iam_role" "dms-access-for-endpoint" {
#   assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
#   name               = "dms-access-for-endpoint"
# }

# resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
#   role       = aws_iam_role.dms-access-for-endpoint.name
# }

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}

# Create a new replication instance
resource "aws_dms_replication_instance" "replication_inst" {
  # checkov:skip=BC_AWS_PUBLIC_13: ADD REASON
  # checkov:skip=BC_AWS_GENERAL_147: ADD REASON
  allocated_storage            = 20
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = "eu-west-1a"
  engine_version               = "3.4.7"
#   kms_key_arn                  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  multi_az                     = false
  preferred_maintenance_window = "sun:10:00-sun:12:00"
  publicly_accessible          = true
  replication_instance_class   = "dms.t2.medium"
  replication_instance_id      = "onprem-to-cloud-db"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.repli_subnet_group.id
  tags = {
    Name = "onpremcloud"
  }

  vpc_security_group_ids = [ aws_security_group.db_sg.id]
  
  depends_on = [
    # aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole,
    aws_dms_replication_subnet_group.repli_subnet_group
  ]
}

resource "aws_dms_replication_subnet_group" "repli_subnet_group" {
  replication_subnet_group_description = "replication subnet group"
  replication_subnet_group_id          = "dms-replication-subnet-group"

  subnet_ids = [
    data.aws_subnet.database_subnet.id,
    data.aws_subnet.database_subnet1.id,
  ]

  tags = {
    Name = "replication-subnet-group"
  }
}

