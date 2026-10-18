# Allow EC2 instances to assume this IAM role.
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Allow the EC2 instance to read only this project's SSM parameters.
resource "aws_iam_role_policy" "ec2_ssm_read" {
  name = "${var.project_name}-${var.environment}-ssm-read"
  role = aws_iam_role.ec2_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter"
      ]
      Resource = [
        "arn:aws:ssm:${var.aws_region}:057079472578:parameter/ecommerce-dev-jwt-secret",
        "arn:aws:ssm:${var.aws_region}:057079472578:parameter/ecommerce-dev-mongodb-uri-user",
        "arn:aws:ssm:${var.aws_region}:057079472578:parameter/ecommerce-dev-mongodb-uri-product",
        "arn:aws:ssm:${var.aws_region}:057079472578:parameter/ecommerce-dev-mongodb-uri-cart",
        "arn:aws:ssm:${var.aws_region}:057079472578:parameter/ecommerce-dev-mongodb-uri-order"
      ]
    }]
  })
}

# Attach the role to EC2 through an instance profile.
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
