resource "aws_iam_instance_profile" "ssm_profile_auto" {
  name = "ssm-profile-auto2"
  role = aws_iam_role.ssm_role_auto.id
}
resource "aws_iam_role" "ssm_role_auto" {
  name               = "ssm-automation"
  path               = "/"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
    }
    EOF
}
resource "aws_iam_policy_attachment" "ssm_attach_ec2" {
  name       = "ssm-ec2-attachment"
  roles      = [aws_iam_role.ssm_role_auto.id]
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "cloudwatch-attach" {
  name  = "cloudwatch-ec2-attachment"
  roles = [aws_iam_role.ssm_role_auto.id]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  #policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM" ,
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "ssm-attach-smm" {
  name       = "ssm-attachment-Ec2-role"
  roles      = [aws_iam_role.ssm_role_auto.id]
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

}

resource "aws_iam_policy_attachment" "ssm-attach-cwagent" {
  name       = "cloudwatch-attachment-Ec2-role"
  roles      = [aws_iam_role.ssm_role_auto.id]
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}