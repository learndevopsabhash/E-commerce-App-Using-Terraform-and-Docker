
output "ec2_public_ip" {
  description = "Public IP address of the e-commerce EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the e-commerce EC2 instance"
  value       = aws_instance.app.public_dns
}
