#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y wget curl vim gnupg
sudo apt install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
sudo mysql -e "FLUSH PRIVILEGES;"

wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-1+debian12_all.deb
sudo dpkg -i zabbix-release_7.0-1+debian12_all.deb
sudo apt update -y

sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2
sudo apt install -y apache2 php php-mbstring php-gd php-xml php-bcmath

sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

sudo sed -i 's/# DBPassword=/DBPassword=zabbix_password/' /etc/zabbix/zabbix_server.conf

sudo systemctl restart zabbix-server zabbix-agent2 apache2
sudo systemctl enable zabbix-server zabbix-agent2 apache2

sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 128M/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 16M/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 2M/' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^;date.timezone =.*/date.timezone = Europe\/Prague/' /etc/php/7.4/apache2/php.ini

sudo systemctl restart apache2
