module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "cloud-migration-vpc"
  cidr = var.vpc_cidr

  azs              = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  private_subnets  = [for i, v in local.availability-zones : cidrsubnet(local.private_subnet_cidr, 4, i)]
  database_subnets = [for i, v in local.availability-zones : cidrsubnet(local.database_subnet_cidr, 1, i)]
  public_subnets   = [for i, v in local.availability-zones : cidrsubnet(local.public_subnet_cidr, 1, i)]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
  enable_flow_log           = true
  flow_log_destination_arn  = aws_s3_bucket.vpc_logs.arn
  flow_log_destination_type = "s3"

  private_subnet_tags = {Name = "private-cloud"}
  public_subnet_tags = {Name = "public-cloud"}
  database_subnet_tags = {Name = "database-cloud"}
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

