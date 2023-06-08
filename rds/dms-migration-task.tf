
resource "aws_dms_replication_task" "test" {
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.replication_inst.replication_instance_arn
  replication_task_id       = "mysql-to-rds"
  replication_task_settings = file("${path.module}/task-settings.json")
  source_endpoint_arn       = aws_dms_endpoint.source.endpoint_arn
  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"customer_db\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
  start_replication_task = true
  tags = {
    Name = "onpremtocloud-rds"
  }

  target_endpoint_arn = aws_dms_endpoint.target.endpoint_arn
}