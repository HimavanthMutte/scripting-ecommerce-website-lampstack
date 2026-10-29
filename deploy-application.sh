

sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld


sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

cat > configure-db.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF
sudo mysql < configure-db.sql

sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd