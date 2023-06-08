#!/bin/bash

# Set MySQL root password
mysql_username="${mysql_root_username}"
mysql_password="${mysql_root_password}"

# Set remote MySQL server details
remote_mysql_host="${db_endpoint}"
phpmyadmin_server_ip="${server_ip}"
DB_ROOT_PASS="${db_login_passowrd}"


# Configure phpMyAdmin to connect to remote MySQL server
sudo sed -i "s/\$dbserver='.*';/\$dbserver='$remote_mysql_host';/g" /etc/phpmyadmin/config-db.php

mysql -u $mysql_username -h $remote_mysql_host -p$mysql_password -e "CREATE USER '$mysql_username'@'$phpmyadmin_server_ip' IDENTIFIED BY '$DB_ROOT_PASS';"
mysql -u $mysql_username -h $remote_mysql_host -p$mysql_password -e "GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO '$mysql_username'@'$phpmyadmin_server_ip' WITH GRANT OPTION; FLUSH PRIVILEGES;"

