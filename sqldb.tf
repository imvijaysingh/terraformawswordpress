resource "aws_security_group" "sql" {
  name        = "mariabdb-sql"
  description = "wp sql connection and egress protocals"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "mariadb-sql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "sql" {
  ami             = "ami-09a7bbd08886aafdf" 
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mycloudkey1.key_name
  vpc_security_group_ids = [aws_security_group.sql.id]
  subnet_id       = aws_subnet.private.id
  user_data       = <<EOT
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo yum install -y mariadb-server
  sudo systemctl start mariadb
  sudo systemctl enable mariadb
  mysql -u root <<EOF
  CREATE USER 'wordpress-user'@'${aws_instance.wp.private_ip}' IDENTIFIED BY 'password@123';
  CREATE DATABASE wordpress_db;
  GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress-user'@'${aws_instance.wp.private_ip}';
  FLUSH PRIVILEGES;
  exit
  EOF
  EOT


  
  tags = {
    Name = "sql"
  }
}
