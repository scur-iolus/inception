FROM debian:buster

RUN apt-get -y update && apt-get install -y mariadb-server \
	rm -rf /var/lib/apt/lists/*

# default port of both MySQL and MariaDB
EXPOSE 3306/tcp

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
	CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD ["mysqld"]
