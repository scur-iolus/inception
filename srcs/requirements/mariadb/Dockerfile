FROM debian:buster

# to avoid debian harmless warnings
ARG DEBIAN_FRONTEND=teletype

RUN apt-get -q -y update &&\
	apt-get -q -y install mariadb-server-10.3 &&\
	rm -rf /var/lib/apt/lists/* &&\
	# makes MariaDB service directory
	mkdir -p /var/run/mysqld &&\
	# gives mysql user permission to write to the service directory
	chown -R mysql:mysql /var/run/mysqld &&\
	chown -R mysql:mysql /var/lib/mysql &&\
	# changes the permissions to rwx for all users
	chmod 777 /var/run/mysqld

# default port of both MySQL and MariaDB
EXPOSE 3306/tcp

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
	CMD mariadb -e 'SELECT @@datadir;' || exit 1

COPY ./utils/setup.sh .
COPY ./utils/queries.sql .

ARG MYSQL_DATABASE
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_USER
ARG MYSQL_PASSWORD

RUN chmod a+r ./queries.sql &&\
	chmod a+x ./setup.sh &&\
	sh ./setup.sh &&\
	rm ./setup.sh ./queries.sql

USER mysql

# changes the bind-address to 'all' instead of 127.0.0.1 only (default on Debian)
# allowing the MariaDB server to listen on all IPv4 addresses
CMD [ "mysqld", "--bind-address=0.0.0.0" ]
