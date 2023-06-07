data "aws_vpc" "on_prem"{
#  cidr_block = "192.168.0.0/16"
 provider = aws.virgina
  filter {
    name = "tag:Name"
    values = ["onprem-migration-vpc"]
  }
}

data "aws_vpc" "cloud"{
  # cidr_block = "10.0.0.0/16"
  filter {
    name = "tag:Name"
    values = ["cloud-migration-vpc"]
  }
}

data "aws_route_table" "cloud" {
  vpc_id = data.aws_vpc.cloud.id
  filter {
    name = "tag:Name"
    values = ["cloud-migration-vpc-default"]
  }
}
data "aws_route_table" "onprem" {
  provider = aws.virgina
  vpc_id = data.aws_vpc.on_prem.id
  filter {
    name = "tag:Name"
    values = ["onprem-migration-vpc-default"]
  }
}

data "aws_route_table" "on_prem_private" {
  provider = aws.virgina
  vpc_id = data.aws_vpc.on_prem.id
  filter {
    name = "tag:Name"
    values = ["onprem-migration-vpc-private"]
  }
}

data "aws_route_table" "cloud_private" {
  vpc_id = data.aws_vpc.cloud.id
  filter {
    name = "tag:Name"
    values = ["cloud-migration-vpc-private"]
  }
}