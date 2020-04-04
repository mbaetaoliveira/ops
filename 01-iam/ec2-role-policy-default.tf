resource "aws_iam_policy" "describe_tags_policy" {
  name = "Describe-Tags-Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PuppetDescribeTags",
      "Action": [
         "ec2:DescribeTags"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}

EOF
}
