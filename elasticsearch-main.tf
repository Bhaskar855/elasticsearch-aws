provider "aws" {
  access_key = "AKIAYR5PC2SIRAVFYPGI"
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

resource "aws_iam_role" "elasticsearch1" {
  name = "module.user_label.id"
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

resource "aws_iam_policy" "elasticsearch1" {
  name   = "module.user_label.id"
  policy = "${data.aws_iam_policy_document.elasticsearch_iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch_iam_role_policy" {
  role       = "${aws_iam_role.elasticsearch_iam_role.name}"
  policy_arn = "${aws_iam_policy.elasticsearch_iam_policy.arn}"
}

resource "aws_iam_instance_profile" "elasticsearch_profile" {
  name  = "elasticsearch_profile"
  role = "${aws_iam_role.elasticsearch_iam_role.name}"
}
