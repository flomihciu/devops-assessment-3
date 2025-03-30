resource "aws_security_group" "bastion_sg" {
  name        = "flo-bastion-sg"
  description = "Allow SSH access to the bastion host"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH from anywhere (temporary)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 🔒 change this to GitHub Actions IP range later
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flo-bastion-sg"
    Description = "Security group for bastion host"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-084568db4383264d4" 
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name        = "flo-bastion-host"
    Description = "Public bastion host for SSH jump access"
  }
}
