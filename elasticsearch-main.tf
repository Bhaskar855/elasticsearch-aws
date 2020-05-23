provider "aws" {
  access_key = "AKIAYR5PC2SI5VR6YY53"
  secret_key = "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"
  region     = "us-east-2"
}

# Security Group - allow SSH and TCP on port 9200 and 9300 (Elasticsearch API endpoint)
resource "aws_security_group" "elasticsearch_cluster_sg" {
  name        = "elasticsearch_cluster_sg"
  description = "Elasticsearch security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "elasticsearch" {
  name = "elasticsearch"
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

data "aws_iam_policy_document" "elasticsearch_iam_policy_document" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeInstances"
    ]

    resources = [
      "*"
    ]
  }
}

resource "custompolicy" "custompolicy" {
  name   = "custompolicy"
  policy = "data.custompolicy_document.custompolicy_document.json"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_iam_role_policy" {
  role       = "elasticsearch"
  policy_arn = "arn:aws:iam::588240835729:policy/custompolicy"
}

resource "aws_iam_instance_profile" "elasticsearch_profile" {
  name  = "elasticsearch_profile"
  role = "elasticsearch"
}
