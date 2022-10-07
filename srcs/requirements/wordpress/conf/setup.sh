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
	SALT=$(curl -s -L https://api.wordpress.org/secret-key/1.1/salt/)
	STRING='put your unique phrase here'
	# appends a newline to the end,
	# g enables the "global" option (each instance of $STRING will be replaced)
	# d tells the regex engine in ED to delete the entire line
	# a tells ED to add whatever string that comes next to the file buffer at the current pointer
	# . tells ED that no more text is coming
	# w writes the contents of the buffer to disk
	printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php
	wp config set DB_NAME "MYSQL_DATABASE" --allow-root
	wp config set DB_USER "MYSQL_USER" --allow-root
	wp config set DB_PASSWORD "MYSQL_PASSWORD" --allow-root
	wp config set DB_HOST "MYSQL_HOST" --allow-root
	wp config set FS_METHOD 'direct' --allow-root
	green "✅ Successfully updated Wordpress config file\n"
fi

green "🚀 Launching php-fpm...\n"
/usr/sbin/php-fpm7.3 -F
