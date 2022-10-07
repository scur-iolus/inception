FROM debian:buster

# to avoid debian harmless warnings
ARG DEBIAN_FRONTEND=teletype

# cleaning up the apt cache after upgrade to keep the image size down
# PHP PDO: MariaDB connector
# PHP CURL: for some plugins
# PHP GD: image operations
# PHP INTL: internationalization support
RUN apt-get -y update && \
	apt-get -y install php-fpm php-mysql curl \
	php-curl php-gd php-intl curl ed && \
	rm -rf /var/lib/apt/lists/*

RUN groupadd wordpress &&\
	useradd --shell /bin/bash -g wordpress wordpress &&\
	mkdir -p /var/www/html &&\
	mkdir -p /run/php &&\
	chown -R wordpress:wordpress /var/www/html &&\
	chmod -R o-rwx /var/www/html

# installing wp-cli https://wp-cli.org/
RUN curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	php wp-cli.phar --info &&\
	chmod +x wp-cli.phar &&\
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

WORKDIR /var/www/html

COPY ./conf/setup.sh .

RUN chmod +x ./setup.sh

EXPOSE 9000

ENTRYPOINT ["sh", "./setup.sh"]
