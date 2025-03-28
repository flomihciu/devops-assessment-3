variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_ingress_ip" {
  description = "Your public IP address in CIDR notation for SSH access"
  type        = string
}

variable "ec2_key_pair_name" {
  description = "Name of the EC2 key pair to use for SSH access"
  type        = string
}
