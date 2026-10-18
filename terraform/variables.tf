
variable "project_name" {
  description = "Name prefix for the e-commerce infrastructure"
  type        = string
  default     = "ecommerce"
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type for the Docker application"
  type        = string
  default     = "t3.small"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
