FROM debian:buster

RUN apt-get -y update &&\
	apt-get install -y mariadb-server-10.3 &&\
	rm -rf /var/lib/apt/lists/* &&\
	# makes MariaDB service directory
	mkdir -p /var/run/mysqld &&\
	# gives mysql user permission to write to the service directory
	chown -R mysql:mysql /var/run/mysqld &&\
	# changes the permissions to rwx for everyone
	chmod 755 /var/run/mysqld

# default port of both MySQL and MariaDB
EXPOSE 3306/tcp

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
	CMD mariadb -e 'SELECT @@datadir;' || exit 1

COPY ./utils/db_setup.sh .
COPY ./utils/queries.sql .

RUN chmod +r ./queries.sql && chmod +x ./db_setup.sh

ENTRYPOINT ["./db_setup.sh"]

# changes the bind-address to 'all' instead of 127.0.0.1 only,
# allowing the MariaDB server to listen on all IPv4 addresses
CMD ["mysqld", "--bind-address=0.0.0.0"]
