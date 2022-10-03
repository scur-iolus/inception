#!/bin/bash

green() {
	echo "\e[32m${1}\e[0m"
}

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
	green "⏩ $MYSQL_DATABASE database found, skipping initialization\n"
else
	# https://mariadb.com/kb/en/mysql_install_db/
	mysql_install_db --auth-root-authentication-method=normal

	until [ -d "/var/lib/mysql/test" ]
	do
		echo "⏳ Waiting for mysql_install_db...\n" && sleep 2
	done
	green "✅ The MariaDB data directory has been initialized\n"

	# we could run mysql_secure_installation script with a heredoc to answer its questions
	# but we'll manually improve the security of the MariaDB installation
	basic_single_escape () {
		echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
	}
	export esc_pass_root=`basic_single_escape "$MYSQL_ROOT_PASSWORD"`
	export esc_pass_usr=`basic_single_escape "$MYSQL_PASSWORD"`

	# several ways here to manually starts MariaDB server
	# see https://mariadb.com/kb/en/starting-and-stopping-mariadb-automatically/
	/usr/share/mysql/mysql.server start

	until [ -n "$(mariadb -e 'SELECT @@datadir;' 2> /dev/null)" ]
	do
		echo "⏳ Waiting for the server to be ready to accept connections...\n" && sleep 2
	done

	# replaces the env variables by their values and run the SQL queries
	# not very clean but avoid installing envsubst and using eval
	( echo "cat <<EOF" ; cat queries.sql ; echo EOF ) | sh | mysql -u root
	green "✅ Successfully ran the installation script\n"

	# manually stops MariaDB server
	/usr/share/mysql/mysql.server stop
fi

# changes the bind-address to 'all' instead of 127.0.0.1 only (default on Debian)
# allowing the MariaDB server to listen on all IPv4 addresses
green "🚀 Launching the MariaDB server...\n"
mysqld --bind-address=0.0.0.0
