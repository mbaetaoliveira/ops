resource "aws_iam_role_policy" "live_smtx" {
  name = "live-smtx"
  role = "${aws_iam_role.live_smtx.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:Describe*",
                "aws-portal:ViewBilling",
                "aws-portal:ViewUsage",
                "cloudformation:ListStacks",
                "cloudformation:ListStackResources",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStackResources",
                "cloudformation:GetTemplate",
                "cloudfront:Get*",
                "cloudfront:List*",
                "cloudtrail:DescribeTrails",
                "cloudtrail:GetEventSelectors",
                "cloudtrail:ListTags",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "config:Get*",
                "config:Describe*",
                "config:Deliver*",
                "config:List*",
                "cur:Describe*",
                "dms:Describe*",
                "dms:List*",
                "dynamodb:DescribeTable",
                "dynamodb:List*",
                "ec2:Describe*",
                "ec2:GetReservedInstancesExchangeQuote",
                "ecs:List*",
                "ecs:Describe*",
                "elasticache:Describe*",
                "elasticache:ListTagsForResource",
                "elasticbeanstalk:Check*",
                "elasticbeanstalk:Describe*",
                "elasticbeanstalk:List*",
                "elasticbeanstalk:RequestEnvironmentInfo",
                "elasticbeanstalk:RetrieveEnvironmentInfo",
                "elasticfilesystem:Describe*",
                "elasticloadbalancing:Describe*",
                "elasticmapreduce:Describe*",
                "elasticmapreduce:List*",
                "es:List*",
                "es:Describe*",
                "firehose:ListDeliveryStreams",
                "firehose:DescribeDeliveryStream",
                "iam:List*",
                "iam:Get*",
                "iam:GenerateCredentialReport",
                "kinesis:Describe*",
                "kinesis:List*",
                "kms:DescribeKey",
                "kms:GetKeyRotationStatus",
                "kms:ListKeys",
                "lambda:List*",
                "logs:Describe*",
                "redshift:Describe*",
                "route53:Get*",
                "route53:List*",
                "rds:Describe*",
                "rds:ListTagsForResource",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetBucketLogging",
                "s3:GetBucketPolicy",
                "s3:GetBucketTagging",
                "s3:GetBucketVersioning",
                "s3:GetBucketWebsite",
                "s3:List*",
                "sagemaker:Describe*",
                "sagemaker:List*",
                "savingsplans:DescribeSavingsPlans",
                "sdb:GetAttributes",
                "sdb:List*",
                "ses:Get*",
                "ses:List*",
                "sns:Get*",
                "sns:List*",
                "sqs:GetQueueAttributes",
                "sqs:ListQueues",
                "storagegateway:List*",
                "storagegateway:Describe*",
                "workspaces:Describe*"
   
            ],
            "Resource": "*"
        }
  ]
}
EOF
}

resource "aws_iam_role" "live_smtx" {
  name        = "live-smtx"
  description = "smtx - get resources aws"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    company = "${local.company}"
    env     = "${local.env}"
    group   = "${local.group}"
    role    = "credential"
    system  = "smtx"
    type    = "service"
  }
}
