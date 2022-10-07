green() {
	echo "\e[32m${1}\e[0m"
}

if [ -d "/var/www/html/wp-content" ]
then
	green "⏩ Wordpress seems to be ready to run, skipping installation\n"
else
	green "📩 Downloading Wordpress...\n"
	wp core download --locale=fr_FR --quiet
	echo ""
	green "✅ Successfully downloaded the latest Wordpress version\n"
	# keys and salts are automatically generated
	wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" --dbhost="$MYSQL_HOST" --skip-check --quiet
	green "✅ Successfully created a Wordpress config file\n"
	while true
	do
		wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_name="$ADMIN_NAME" \
			--admin_email="$ADMIN_EMAIL" --admin_password="$ADMIN_PWD" --skip-email \
				--quiet 2> /dev/null
		if [ $? -eq 0 ]; then
			break
		fi
		echo "⏳ Waiting for mariadb to be ready...\n" && sleep 2
	done
	# wp rewrite structure '/%postname%/' --hard
	# wp rewrite flush --hard
fi

green "🚀 Launching php-fpm...\n"
/usr/sbin/php-fpm7.3 -F
