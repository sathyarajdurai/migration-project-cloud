data "aws_vpc" "on_prem"{
  filter {
    name = "tag:Name"
    values = ["onprem-migration-vpc"]
  }
}

data "aws_vpc" "cloud"{
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
  vpc_id = data.aws_vpc.on_prem.id
  filter {
    name = "tag:Name"
    values = ["onprem-migration-vpc-default"]
  }
}