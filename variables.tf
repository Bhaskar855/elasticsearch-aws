variable "aws_region" {
  default     = "us-east-2"
}

variable "aws_access_key" "AKIAYR5PC2SI5VR6YY53"

variable "aws_secret_key" "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"

# Need to provide a Red-Hat based image
variable "aws_ami" {
  default = "ami-XXXXXX"
}

variable "aws_instance_type" {
  default     = "t2.medium"
}
