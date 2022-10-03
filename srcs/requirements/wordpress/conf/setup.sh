green() {
	echo "\e[32m${1}\e[0m"
}

if [ -d "/var/www/html/wordpress/wp-content" ]
then
	green "⏩ Wordpress seems to be ready to run, skipping installation\n"
else
	green "📩 Downloading Wordpress...\n"
	wget --quiet -P /var/www/html/ https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz
	rm -rf latest.tar.gz
	green "✅ Successfully downloaded the latest Wordpress version\n"
	cd wordpress
	mv wp-config-sample.php wp-config.php

	echo "\n/* Lines automatically added by a custom script */" >> wp-config.php
	wget --quiet https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
	echo "define('DB_NAME', '$MYSQL_DATABASE');" >> wp-config.php
	echo "define('DB_USER', '$MYSQL_USER');" >> wp-config.php
	echo "define('DB_PASSWORD', '$MYSQL_PASSWORD');" >> wp-config.php
	echo "define('DB_HOST', '$MYSQL_HOST');" >> wp-config.php
	echo "define('FS_METHOD', 'direct');" >> wp-config.php
	green "✅ Successfully updated Wordpress config file\n"
fi

green "🚀 Launching php-fpm...\n"
/usr/sbin/php-fpm7.3 -F
