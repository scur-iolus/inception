green() {
	echo "\e[32m${1}\e[0m"
}

if [ -d "/var/www/html/wp-content" ]
then
	green "⏩ Wordpress seems to be ready to run, skipping installation\n"
else
	green "📩 Downloading Wordpress...\n"
	wp core download --locale=fr_FR
	green "✅ Successfully downloaded the latest Wordpress version\n"
	# keys and salts are automatically generated
	wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" --dbhost="$MYSQL_HOST" --skip-check
	green "✅ Successfully created a Wordpress config file\n"
fi

green "🚀 Launching php-fpm...\n"
/usr/sbin/php-fpm7.3 -F
