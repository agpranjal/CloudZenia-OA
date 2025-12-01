# Create EC2 Key Pair if public_key_path is provided
resource "aws_key_pair" "ec2_key" {
  count = var.public_key_path != null ? 1 : 0

  key_name   = "${var.name_prefix}-ec2-key"
  public_key = file(var.public_key_path)

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-key"
  })
}

# Determine which key name to use
locals {
  key_name = var.key_name != null ? var.key_name : (var.public_key_path != null ? aws_key_pair.ec2_key[0].key_name : null)
}

# Elastic IP for EC2 Instance 1
resource "aws_eip" "ec2_1" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-1-eip"
  })
}

# Elastic IP for EC2 Instance 2
resource "aws_eip" "ec2_2" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-2-eip"
  })
}

# EC2 Instance 1 in Public Subnet 1
resource "aws_instance" "ec2_1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = local.key_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-instance-1"
  })
}

# EC2 Instance 2 in Public Subnet 2
resource "aws_instance" "ec2_2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = local.key_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ec2-instance-2"
  })
}

# Associate Elastic IP with EC2 Instance 1
resource "aws_eip_association" "ec2_1" {
  instance_id   = aws_instance.ec2_1.id
  allocation_id = aws_eip.ec2_1.id
}

# Associate Elastic IP with EC2 Instance 2
resource "aws_eip_association" "ec2_2" {
  instance_id   = aws_instance.ec2_2.id
  allocation_id = aws_eip.ec2_2.id
}

