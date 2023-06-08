

resource "aws_s3_bucket" "elb_logs" {
  # checkov:skip=BC_AWS_GENERAL_72: ADD REASON cross region replication is not needed
  # checkov:skip=BC_AWS_GENERAL_56: ADD REASON it needs SSE-S3 only
  # checkov:skip=BC_AWS_S3_13: ADD REASON access logging will be added later
  # checkov:skip=BC_AWS_S3_62: ADD REASON enable event notificiations will be added later
  bucket = "migration-elb-logs-cr"

  tags = {
    Name        = "elb logs migration"
    Environment = "Lab"
  }

  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_s3_bucket_public_access_block" "elb_bucket" {
  bucket                  = aws_s3_bucket.elb_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "elb_version" {
  bucket = aws_s3_bucket.elb_logs.id

  versioning_configuration {
    status = "Enabled"
  }

}

data "aws_iam_policy_document" "allow_lb" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::migration-elb-logs-cr/elblogs/AWSLogs/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "allow-lb" {
  bucket = aws_s3_bucket.elb_logs.id
  policy = data.aws_iam_policy_document.allow_lb.json
}


resource "aws_s3_bucket_server_side_encryption_configuration" "elb_encryption" {
  bucket = aws_s3_bucket.elb_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "vpc_logs" {
  # checkov:skip=BC_AWS_GENERAL_72: ADD REASON cross region replication not needed
  # checkov:skip=BC_AWS_S3_13: ADD REASON access logging will be added later
  bucket = "migration-vpc-logs-cr"

  tags = {
    Name        = "vpc logs migration"
    Environment = "Lab"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_public_access_block" "vpc_bucket" {
  bucket                  = aws_s3_bucket.vpc_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "vpc_version" {
  bucket = aws_s3_bucket.vpc_logs.id

  versioning_configuration {
    status = "Enabled"
  }

}


data "aws_iam_policy_document" "allow_vpc" {
  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::migration-vpc-logs-cr",
      "arn:aws:s3:::migration-vpc-logs-cr/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        local.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:*:${local.account_id}:*"
      ]
    }
  }
  statement {
    sid = "AWSLogDeliveryCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::migration-vpc-logs-cr",
      "arn:aws:s3:::migration-vpc-logs-cr/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        local.account_id
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:*:${local.account_id}:*"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "allow-vpc" {
  bucket = aws_s3_bucket.vpc_logs.id
  policy = data.aws_iam_policy_document.allow_vpc.json
}


resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_encryption" {
  bucket = aws_s3_bucket.vpc_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


