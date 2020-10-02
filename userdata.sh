#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd php-gd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sleep 20
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i 's/database_name_here/wordpress_db/g' wordpress/wp-config.php
sed -i 's/username_here/wordpress-user/g' wordpress/wp-config.php
sed -i 's/password_here/password@123/g' wordpress/wp-config.php
sed -i 's/localhost/${aws_instance.sql.private_ip}/g' wordpress/wp-config.php
sudo cp -r wordpress/* /var/www/html/
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
sudo sed -i  '151s/.*/AllowOverride All/' httpd.conf
sudo systemctl start httpd
sudo systemctl enable http
sleep 20
