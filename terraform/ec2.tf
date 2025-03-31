resource "aws_instance" "app_server" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_pair_name
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<EOF
#!/bin/bash
apt update && apt install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
EOF

  tags = {
    Name        = "flo-app-server"
    Description = "EC2 instance for Flo application"
  }
}
