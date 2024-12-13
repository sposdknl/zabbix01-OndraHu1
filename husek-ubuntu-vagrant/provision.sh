#!/bin/bash

# Aktualizace systému
sudo dnf update -y

# Instalace základních nástrojů
sudo dnf install -y wget curl vim gnupg2

# Instalace MySQL serveru (MariaDB)
sudo dnf install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Konfigurace databáze pro Zabbix
sudo mysql -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Přidání Zabbix 7.0 LTS repository
wget https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-7.0-1.el9.noarch.rpm
sudo dnf install -y zabbix-release-7.0-1.el9.noarch.rpm
sudo dnf clean all
sudo dnf makecache

# Instalace Zabbix serveru, frontend, Apache a PHP
sudo dnf install -y zabbix-server-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-agent2
sudo dnf install -y httpd php php-mbstring php-gd php-xml php-bcmath

# Import Zabbix databázové struktury
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pzabbix_password zabbix

# Disable log_bin_trust_function_creators option after importing database schema.
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# Konfigurace Zabbix serveru
sudo sed -i 's/# DBPassword=/DBPassword=zabbix_password/' /etc/zabbix/zabbix_server.conf

# Spuštění Zabbix serveru a agenta
sudo systemctl restart zabbix-server zabbix-agent2 httpd
sudo systemctl enable zabbix-server zabbix-agent2 httpd

# Konfigurace PHP pro Zabbix frontend
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 128M/' /etc/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 16M/' /etc/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 2M/' /etc/php.ini
sudo sed -i 's/^;date.timezone =.*/date.timezone = Europe\/Prague/' /etc/php.ini

# Restart Apache pro načtení změn
sudo systemctl restart httpd
