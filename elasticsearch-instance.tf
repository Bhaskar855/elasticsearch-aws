resource "aws_instance" "elasticsearch_instance" {
  ami           = "ami-0a54aef4ef3b5f881"
  instance_type = "t2.micro"
  security_groups = ["launch-wizard-16"]
  iam_instance_profile = "${aws_iam_instance_profile.elasticsearch_profile.name}"
  user_data = "${file("elasticsearch-node-setup.sh")}"
  count = "2"

  tags {
    Name = "elasticsearch_instance"
  }
}
