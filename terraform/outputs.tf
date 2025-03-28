output "ec2_public_ip" {
  description = "Public IP address of the EC2 app server"
  value       = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint for the PostgreSQL database"
  value       = aws_db_instance.db.endpoint
}
