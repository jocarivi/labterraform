resource "aws_db_instance" "my_rds_instance" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.32"  
  instance_class       = "db.t3.micro"  
  db_name              = "db_rds_jcricardo"  
  username             = "admin"  
  password             = "password"  
  parameter_group_name = "default.mysql8.0"  
  skip_final_snapshot  = true
  publicly_accessible  = true  

  vpc_security_group_ids = [aws_security_group.rds_sg.id]  
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name  

  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]  

  tags = {
    Name = "MyDBSubnetGroup"
  }
}
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]  # Cambia este bloque CIDR por el rango de tu VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDSSecurityGroup"
  }
}