FROM debian:buster

# to avoid debian harmless warnings
ARG DEBIAN_FRONTEND=teletype

# cleaning up the apt cache after upgrade to keep the image size down
# PHP PDO: MariaDB connector
# PHP CURL: for some plugins
# PHP GD: image operations
# PHP INTL: internationalization support
RUN apt-get -y update && \
	apt-get -y install php-fpm php-mysql php-curl \
	php-gd php-intl wget && \
	rm -rf /var/lib/apt/lists/*

RUN groupadd wordpress &&\
	useradd --shell /bin/bash -g wordpress wordpress &&\
	mkdir -p /var/www/html &&\
	mkdir -p /run/php &&\
	chown -R wordpress:wordpress /var/www/html &&\
	chmod -R o-rwx /var/www/html

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

WORKDIR /var/www/html

COPY ./conf/setup.sh .

RUN chmod +x ./setup.sh

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "./setup.sh"]
