wget --quiet -P /var/www/html/ https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm -rf latest.tar.gz
cd wordpress
mv wp-config-sample.php wp-config.php

echo "" >> wp-config.php
echo "/* Lines automatically added by a custom script */" >> wp-config.php
wget --quiet https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
echo "define('DB_NAME', '$MYSQL_DATABASE');" >> wp-config.php
echo "define('DB_USER', '$MYSQL_USER');" >> wp-config.php
echo "define('DB_PASSWORD', '$MYSQL_PASSWORD');" >> wp-config.php
echo "define('DB_HOST', '$MYSQL_HOST');" >> wp-config.php

echo "define('FS_METHOD', 'direct');" >> wp-config.php

/usr/sbin/php-fpm7.3 -F
