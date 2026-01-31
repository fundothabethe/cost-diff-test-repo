# Test Infrastructure for Cost Diff Bot
# This represents a typical web application setup

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # Singapore region
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "test-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "private-subnet"
  }
}

# NAT Gateway for private subnet
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat-gateway"
  }

  depends_on = [aws_internet_gateway.main]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Security Groups
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = {
    Name = "db-sg"
  }
}

# EC2 Instances
resource "aws_instance" "web" {
  count                  = 2
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t3.medium"
  key_name              = "my-key-pair"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id             = aws_subnet.public.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    iops        = 3000
    throughput  = 125
  }

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

# EBS Volume for additional storage
resource "aws_ebs_volume" "data" {
  availability_zone = "ap-southeast-1a"
  size              = 100
  type              = "gp3"
  iops              = 4000
  throughput        = 200

  tags = {
    Name = "data-volume"
  }
}

resource "aws_volume_attachment" "data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.web[0].id
}

# RDS Database
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "main-database"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.small"
  db_name                = "myapp"
  username               = "dbuser"
  password               = "changeme123!"
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true

  tags = {
    Name = "main-database"
  }
}
