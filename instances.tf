resource "aws_instance" "bg_blue" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bg_subnet.id
  vpc_security_group_ids = [aws_security_group.bg_web_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html
              echo "<h1>VAMSI BLUE ENVIRONMENT</h1>" > /var/www/html/index.html
              chown apache:apache /var/www/html/index.html
              chmod 644 /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF
  tags = {
    Name = "blue_instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "bg_green" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bg_subnet.id
  vpc_security_group_ids = [aws_security_group.bg_web_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html
              echo "<h1>VAMSI GREEN ENVIRONMENT</h1>" > /var/www/html/index.html
              chown apache:apache /var/www/html/index.html
              chmod 644 /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF
  tags = {
    Name = "green_instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}
