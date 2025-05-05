# SECURITY GROUP
resource "aws_security_group" "vpc_sg_pub" {
  vpc_id = var.vpc_id
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 INSTANCE
data "template_file" "user_data" {
  template = file("./modules/compute/scripts/user_data.sh")
}

resource "aws_instance" "instance-a" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_az1a_id
  vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
  user_data              = base64encode(data.template_file.user_data.rendered)
}