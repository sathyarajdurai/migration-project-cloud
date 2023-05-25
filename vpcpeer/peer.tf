resource "aws_vpc_peering_connection" "migration" {
  peer_owner_id = 744618523292
  peer_vpc_id   = data.aws_vpc.on_prem.id
  vpc_id        = data.aws_vpc.cloud.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# resource "aws_vpc_peering_connection_options" "foo" {
#   vpc_peering_connection_id = aws_vpc_peering_connection.migration.id

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_vpc_to_remote_classic_link = true
#     allow_classic_link_to_remote_vpc = true
#   }
# }

resource "aws_route" "route_cloud" {
  route_table_id            = data.aws_route_table.cloud.id
  destination_cidr_block    = var.onprem_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.migration.id
}

resource "aws_route" "route_onprem" {
  route_table_id            = data.aws_route_table.onprem.id
  destination_cidr_block    = var.cloud_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.migration.id
}