resource "aws_athena_workgroup" "vpc_flow_logs_wg" {
  name = "migration-vpc-flow-logs"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.vpc_logs.bucket}/"
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = true
}

resource "aws_athena_database" "vpc_flow_logs" {
  name   = "vpc_flow_logs"
  bucket = aws_s3_bucket.vpc_logs.bucket
  force_destroy = true
}
resource "aws_athena_named_query" "table_schema" {
  name      = "vpc-create-table-query"
  workgroup = aws_athena_workgroup.vpc_flow_logs_wg.id
  database  = aws_athena_database.vpc_flow_logs.name
  query = <<QUERY

  CREATE EXTERNAL TABLE IF NOT EXISTS table_vpc_logs (
  version int,
  account_id string,
  interface_id string,
  srcaddr string,
  dstaddr string,
  srcport int,
  dstport int,
  protocol bigint,
  packets bigint,
  bytes bigint,
  start bigint,
  `end` bigint,
  action string,
  log_status string,
  vpc_id string,
  subnet_id string,
  instance_id string,
  tcp_flags int,
  type string,
  pkt_srcaddr string,
  pkt_dstaddr string,
  az_id string,
  sublocation_type string,
  sublocation_id string,
  pkt_src_aws_service string,
  pkt_dst_aws_service string,
  flow_direction string,
  traffic_path int
)
PARTITIONED BY (region string, day string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
LOCATION 's3://migration-vpc-logs-cr/AWSLogs/722257929281/vpcflowlogs/eu-west-1/'
TBLPROPERTIES
(
"skip.header.line.count"="1",
"projection.enabled" = "true",
"projection.region.type" = "enum",
"projection.region.values" = "eu-west-1",
"projection.day.type" = "date",
"projection.day.range" = "2023/06/05,NOW",
"projection.day.format" = "yyyy/MM/dd",
"storage.location.template" = "s3://migration-vpc-logs-cr/AWSLogs/722257929281/vpcflowlogs/$${region}/$${day}"
)

QUERY

}


 resource "aws_athena_named_query" "vpc_flow_logs_query" {
  name      = "vpc-flow-logs-query"
  workgroup = aws_athena_workgroup.vpc_flow_logs_wg.id
  database  = aws_athena_database.vpc_flow_logs.name
  query     = "SELECT * FROM table_vpc_logs WHERE day > '2023/06/04' limit 20;"
}

resource "aws_athena_named_query" "vpc_flow_logs_ip" {
  name      = "vpc-flow-logs-query-iprange"
  workgroup = aws_athena_workgroup.vpc_flow_logs_wg.id
  database  = aws_athena_database.vpc_flow_logs.name
  query     = "SELECT * FROM table_vpc_logs WHERE dstaddr = '192.168.0.0' limit 20;"
}

