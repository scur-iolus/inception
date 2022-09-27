-- Removes anonymous users
DELETE FROM mysql.user WHERE User='';

-- Removes the test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Disallows root login remotely
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- An invalid password is initially set for root
UPDATE mysql.user SET Password=PASSWORD('$esc_pass_root') WHERE User='root';
CREATE IF NOT EXISTS USER '$MYSQL_USER'@'%' IDENTIFIED BY '$esc_pass_usr';

-- Creates and prepares the Wordpress database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- Reloading the privilege tables will ensure that
-- all changes made so far will take effect immediately
FLUSH PRIVILEGES;

exit;
