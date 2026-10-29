

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

cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF

sudo mysql < configure-db.sql
sudo mysql < db-load-script.sql

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


cat > /var/www/html/.env <<-EOF
DB_HOST=localhost
DB_USER=ecomuser
DB_PASSWORD=ecompassword
DB_NAME=ecomdb
EOF


PHP_FILE="/var/www/html/index.php"
sed -i "/\\\$dbHost = getenv('DB_HOST');/i\\                        loadEnv(__DIR__ . '/.env');" "$PHP_FILE"