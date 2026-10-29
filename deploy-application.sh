

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

sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

sudo yum install php php-mysqlnd -y

sudo yum install -y git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
sudo systemctl reload httpd

