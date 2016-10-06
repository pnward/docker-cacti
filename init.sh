mysql -h mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE < /usr/share/webapps/cacti/cacti.sql
sed -i "s/\$database_hostname = \"localhost\";/\$database_hostname = \"mysql\";/g" /var/www/localhost/htdocs/cacti/include/config.php
sed -i "s/\$database_default = \"cacti\";/\$database_default = \"$MYSQL_DATABASE\";/g" /var/www/localhost/htdocs/cacti/include/config.php
sed -i "s/\$database_username = \"cactiuser\";/\$database_username = \"$MYSQL_USER\";/g" /var/www/localhost/htdocs/cacti/include/config.php
sed -i "s/\$database_password = \"cactiuser\";/\$database_password = \"$MYSQL_PASSWORD\";/g" /var/www/localhost/htdocs/cacti/include/config.php
grep -q '^date_default_timezone_set' /usr/share/webapps/cacti/include/config.php  && sed -i "s/^date_default_timezone_set.*/date_default_timezone_set(\"$TIMEZONE\");/" /usr/share/webapps/cacti/include/config.php || sed -i "s/?>/date_default_timezone_set(\"$TIMEZONE\");\n?>/" /usr/share/webapps/cacti/include/config.php
exec supervisord --nodaemon --configuration /etc/supervisord.conf
