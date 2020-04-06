terraform {
  backend "s3" {
    bucket = "smtx-live-us-east-1"
    key    = "ecr/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_ecr_repository" "repo" {
  count = length(var.repositories) > 0 ? length(var.repositories) : 0

  name = var.repositories[count.index]

  tags = {
    company = "smtx"
    env     = "live"
    group   = "it"
    role    = "store"
    system  = var.repositories[count.index]
    type    = "service"
  }
}


resource "aws_ecr_lifecycle_policy" "policy" {
  count = length(var.repositories) > 0 ? length(var.repositories) : 0

  repository = var.repositories[count.index]
  depends_on = [aws_ecr_repository.repo]

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 800 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["a","b","c","d","e","f","v"],
                "countType": "imageCountMoreThan",
                "countNumber": 800
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last 800 images 0-9",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["0","1","2","3","4","5","6","7","8","9"],
                "countType": "imageCountMoreThan",
                "countNumber": 800
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}

resource "aws_ecr_repository_policy" "policy_pull" {
  count = length(var.repositories) > 0 ? length(var.repositories) : 0

  repository = var.repositories[count.index]
  depends_on = [aws_ecr_repository.repo]

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                "arn:aws:iam::172649094837:root"
                ]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages"
            ]
        }
    ]
}
EOF

}

output "repositories" {
  value = [aws_ecr_repository.repo.*.repository_url]
}

