
resource "aws_db_instance" "cloud_db" {
  depends_on = [ aws_security_group.db_sg, aws_db_subnet_group.rds_subnet_group ]
  allocated_storage    = 20
  storage_type         = "gp3"
  storage_encrypted    = true 
  db_name              = "migrationrds"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.medium"
  username             = "phpmyadmin"
  manage_master_user_password = true
  identifier            = "cloud-rds-db"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  maintenance_window   = "Sun:10:00-Sun:12:00"
  backup_retention_period     = 7
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  auto_minor_version_upgrade = true
  # restore_to_point_in_time {
  #   source_db_instance_automated_backups_arn = "arn:aws:rds:eu-west-1:744618523292:db:cloud-rds-db"
  #   use_latest_restorable_time = true
  # }
}

resource "aws_security_group" "db_sg" {
  name        = "cloud-db-sg"
  description = "Allow db inbound traffic"
  vpc_id      = data.aws_vpc.cloud.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "db port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

  }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "cloud-subnet-group"
  subnet_ids = [data.aws_subnet.database_subnet.id, data.aws_subnet.database_subnet1.id]

  # tags = {
  #   Name = "My DB subnet group"
  # }
}