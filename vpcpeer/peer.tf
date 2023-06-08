# resource "aws_vpc_peering_connection" "migration" {
#   peer_owner_id = data.aws_caller_identity.peer.account_id
#   peer_vpc_id   = data.aws_vpc.on_prem.id
#   vpc_id        = data.aws_vpc.cloud.id
#   auto_accept = true
#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
# }
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_vpc" "onprem_peer" {
#   provider   = aws.virgina
#   cidr_block = "192.168.0.0/16"
# }

data "aws_caller_identity" "peer" {
  provider = aws.virgina
}
resource "aws_vpc_peering_connection" "cloud_peer" {
  vpc_id        = data.aws_vpc.cloud.id
  peer_vpc_id   = data.aws_vpc.on_prem.id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = "us-east-1"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "onprem_peer" {
  provider                  = aws.virgina
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud_peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


resource "aws_route" "route_cloud" {
  route_table_id            = data.aws_route_table.cloud.id
  destination_cidr_block    = var.onprem_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud_peer.id
}

# resource "aws_route" "route_cloud" {
#   route_table_id            = data.aws_route_table.cloud_private.id
#   destination_cidr_block    = var.onprem_cidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.cloud_peer.id
# }

resource "aws_route" "route_onprem" {
  provider = aws.virgina
  route_table_id            = data.aws_route_table.onprem.id
  destination_cidr_block    = var.cloud_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud_peer.id
}

resource "aws_route" "route_onprem_privatesubnet" {
  provider = aws.virgina
  route_table_id            = data.aws_route_table.on_prem_private.id
  destination_cidr_block    = var.cloud_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud_peer.id
}