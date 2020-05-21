resource "aws_instance" "elasticsearch_instance" {
  ami           = "ami-07c1207a9d40bc3bd"
  instance_type = "t2.micro"
  security_groups = ["sg-009ff540c487175bc"]
  iam_instance_profile = "${aws_iam_instance_profile.elasticsearch_profile.name}"
  user_data = "${file("elasticsearch-node-setup.sh")}"
  count = "2"

  tags {
    Name = "elasticsearch_instance_${count.index}"
  }
}
