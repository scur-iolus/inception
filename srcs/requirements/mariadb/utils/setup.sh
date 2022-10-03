#!/bin/bash

if [ -d "/var/lib/mysql/mysql" ]
then
	echo "⏩ The MariaDB data directory is already initialized.";
else
	# https://mariadb.com/kb/en/mysql_install_db/
	mysql_install_db \
	--skip-test-db \
	--auth-root-authentication-method=normal \
	--datadir=/var/lib/mysql &> /dev/null;
	echo "✅ The MariaDB data directory has been initialized.";
fi

# we could run mysql_secure_installation script with a heredoc
# but we'll manually improve the security of the MariaDB installation
basic_single_escape () {
	echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g';
}
export esc_pass_root=`basic_single_escape "$MYSQL_ROOT_PASSWORD"`;
export esc_pass_usr=`basic_single_escape "$MYSQL_PASSWORD"`;

# several ways here https://mariadb.com/kb/en/starting-and-stopping-mariadb-automatically/
# to manually starts MariaDB server
/usr/share/mysql/mysql.server start;

# replaces the env variables by their values and run the SQL queries
( echo "cat <<EOF" ; cat queries.sql ; echo EOF ) | sh | mysql -u root;
echo "✅ Successfully ran the installation script.";

# manually stops MariaDB server
/usr/share/mysql/mysql.server stop;
