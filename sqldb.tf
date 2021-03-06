###### Primary table Private subnet with Egress only to the internet whereas the secondary table will have Internet Gateway for both way connectivity and will be given to public subnet

resource "aws_security_group" "sqlsg" {
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
  ami             = "ami-0e306788ff2473ccb" 
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.devopskey.key_name
  vpc_security_group_ids = [aws_security_group.sqlsg.id]
  subnet_id       = aws_subnet.private.id
  user_data       = <<EOT
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo yum install -y mariadb-server
  sudo systemctl start mariadb
  sudo systemctl enable mariadb
  mysql -u root <<EOF
  CREATE USER 'wordpress-user'@'${aws_instance.wp.private_ip}' IDENTIFIED BY 'myname@123';
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
