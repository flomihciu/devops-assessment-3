output "ec2_public_ip" {
  description = "Public IP address of the EC2 app server"
  value       = aws_instance.app_server.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 app server"
  value       = aws_instance.app_server.private_ip
}

output "rds_endpoint" {
  description = "RDS endpoint for the PostgreSQL database"
  value       = aws_db_instance.db.endpoint
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}
