resource "aws_db_instance" "db" {
  identifier             = "flo-postgres-db"
  engine                 = "postgres"
  instance_class         = var.db_instance_type
  allocated_storage      = 20
  username               = var.db_user
  password               = var.db_password
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name        = "flo-db-instance"
    Description = "PostgreSQL database for Flo application"
  }
}
