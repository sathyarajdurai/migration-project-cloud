

resource "aws_instance" "migrated_web_server" {
  depends_on                  = [aws_network_interface.migrate_web]
  ami                         = data.aws_ami.migrated_ami.id
  instance_type               = "t3.small"
  key_name                    = data.aws_key_pair.cloud_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile_auto.id
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
  # associate_public_ip_address = true
  network_interface {
    network_interface_id = aws_network_interface.migrate_web.id
    device_index         = 0
  }
  user_data = templatefile("${path.module}/webserver-mig.sh.tpl", {
    mysql_root_username = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["username"]
    mysql_root_password = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["password"]
    db_endpoint         = element(split(":", data.aws_db_instance.rds_db.endpoint), 0)
    server_ip           = aws_network_interface.migrate_web.private_ip
    db_login_passowrd   = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string).rdspassword
  })


  tags = {
    Name = "Migrated-webserver-Server"
    Backup = "AMI-backup"
  }
  volume_tags = local.deafult_tags
}

resource "aws_network_interface" "migrate_web" {
  subnet_id       = data.aws_subnet.public.id
  security_groups = [data.aws_security_group.web_server.id]
  description     = "migrtaed-ip"
  # attachment {
  #   instance     = aws_instance.onprem_web_server.id
  #   device_index = 0
  # }
}
