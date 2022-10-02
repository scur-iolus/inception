#!/bin/bash

# https://mariadb.com/kb/en/mysql_install_db/
mysql_install_db \
--skip-test-db \
--auth-root-authentication-method=normal \
--datadir=/var/lib/mysql \
--verbose

# starts the MariaDB daemon
/etc/init.d/mysql start

# we could run mysql_secure_installation script with a heredoc
# but we'll manually improve the security of the MariaDB installation
basic_single_escape () {
	echo "$1" | sed 's/\(['"'"'\]\)/\\\1/g'
}
export esc_pass_root=`basic_single_escape "$MYSQL_ROOT_PASSWORD"`
export esc_pass_usr=`basic_single_escape "$MYSQL_PASSWORD"`
( echo "cat <<EOF" ; cat queries.sql ; echo EOF ) | sh | mysql --user root

# stops the MariaDB daemon
/etc/init.d/mysql stop
