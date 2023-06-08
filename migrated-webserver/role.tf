resource "aws_iam_instance_profile" "ssm_profile1" {
  name = "ssm-profile1"
  role = data.aws_iam_role.ssm_role.id
}
# resource "aws_iam_role" "ssm_role" {
#   name               = "ssm_role"
#   path               = "/"
#   assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                "Service": "ec2.amazonaws.com"
#             },
#             "Effect": "Allow",
#             "Sid": ""
#         }
#     ]
#     }
#     EOF
# }
# resource "aws_iam_policy_attachment" "ssm-attach" {
#   name       = "ssm-attachment"
#   roles      = [aws_iam_role.ssm_role.id]
# #   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
# #   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_policy_attachment" "cloudwatch-attach" {
#   name  = "cloudwatch-attachment"
#   roles = [aws_iam_role.ssm_role.id]
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
#   #policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM" ,
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }