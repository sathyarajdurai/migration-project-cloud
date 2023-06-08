terraform {
  backend "s3" {
    bucket         = "talent-academy-sathyaraj-lab-tfstates3"
    key            = "talent-academy/migration-lab-vpcpeer/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}