

# Crear el grupo de seguridad para permitir HTTP (80) y SSH (22)
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name        = "allow_http_ssh"
  description = "Security group allowing HTTP and SSH traffic"  # Cambia la descripción aquí

  # Permitir tráfico entrante en el puerto 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfico entrante en el puerto 22 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

# Lanzar la primera instancia EC2 en la primera subnet pública
resource "aws_instance" "web1" {
  ami           = "ami-0fff1b9a61dec8a5f"  # Cambia según tu región
  instance_type = "t2.micro"

  key_name = "cloud2"
  user_data = file("createDocker.sh")
  # Asignar la instancia a la primera subnet pública
  subnet_id = aws_subnet.public_subnet_1.id

  # Asociar al grupo de seguridad creado
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer1"
  }
}

# Lanzar la segunda instancia EC2 en la segunda subnet pública
resource "aws_instance" "web2" {
  ami           = "ami-0fff1b9a61dec8a5f"  # Cambia según tu región
  instance_type = "t2.micro"
  # Asignar la instancia a la segunda subnet pública
  subnet_id = aws_subnet.public_subnet_2.id
  key_name = "cloud2"
  
  user_data = file("createDocker1.sh")
  # Asociar al grupo de seguridad creado
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer2"
  }
}

# Salida para ver las direcciones IP públicas de las instancias
output "instance_ips" {
  value = {
    web1_ip = aws_instance.web1.public_ip
    web2_ip = aws_instance.web2.public_ip
  }
}

