#!/bin/bash

# Aktualizace systému
apt update -y
apt upgrade -y

# Instalace potřebných balíčků
apt install -y wget curl gnupg lsb-release sudo

# Přidání Zabbix repozitáře
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb
dpkg -i zabbix-release_latest_7.0+debian12_all.deb
apt update -y

# Instalace Zabbix serveru, frontend a agenta
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Instalace MariaDB místo MySQL
apt install -y mariadb-server

# Vytvoření databáze pro Zabbix v MariaDB
mysql -u root -e "CREATE DATABASE zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -u root -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
mysql -u root -e "SET GLOBAL log_bin_trust_function_creators = 1;"
mysql -u root -e "QUIT;"

# Importování schématu a dat do databáze
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# Deaktivace log_bin_trust_function_creators po importu
mysql -u root -e "SET GLOBAL log_bin_trust_function_creators = 0;"
mysql -u root -e "QUIT;"

# Konfigurace Zabbix serveru
sed -i 's/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf

# Restartování a povolení Zabbix serveru, agenta a Apache
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

# Zobrazení Zabbix UI na webu
echo "Zabbix server a frontend byly úspěšně nainstalovány. Přejděte na http://host/zabbix pro přístup k UI."
