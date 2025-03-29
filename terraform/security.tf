resource "aws_security_group" "app_sg" {
  name        = "flo-app-sg"
  description = "Security group for Flo app server"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH from Bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow internal access to backend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flo-app-sg"
    Description = "Security group for Flo EC2 app server"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "flo-db-sg"
  description = "Allow EC2 app access to Flo RDS"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow DB access from EC2 app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flo-db-sg"
    Description = "RDS security group for Flo PostgreSQL"
  }
}
