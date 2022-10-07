FROM debian:buster

# to avoid debian harmless warnings
ARG DEBIAN_FRONTEND=teletype

# cleaning up the apt cache after upgrade to keep the image size down
# PHP PDO: MariaDB connector
# PHP CURL: for some plugins
# PHP GD: image operations
# PHP INTL: internationalization support
RUN apt-get -q -y update && \
	apt-get -q -y install php-fpm php-mysql \
	php-curl php-gd php-intl curl && \
	rm -rf /var/lib/apt/lists/*

# installing wp-cli https://wp-cli.org/
RUN curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	php wp-cli.phar --info &&\
	mv wp-cli.phar /usr/local/bin/wp &&\
	mkdir -p /run/php &&\
	mkdir -p /var/www/html

COPY ./utils/www.conf /etc/php/7.3/fpm/pool.d/

COPY ./utils/setup.sh /var/www/html/wp_setup.sh

# creates a new user, owner of all useful files
RUN groupadd wordpress &&\
	useradd --shell /bin/bash -g wordpress wordpress &&\
	chown -R wordpress:wordpress /run/php &&\
	chown -R wordpress:wordpress /var/www/html &&\
	chown wordpress:wordpress /usr/local/bin/wp &&\
	chown -R wordpress:wordpress /etc/php/7.3/fpm/pool.d &&\
	chown -R wordpress:wordpress /var/log/ &&\
	mkdir -p /home/wordpress/.wp-cli &&\
	chown wordpress:wordpress /home/wordpress/.wp-cli

# updates files permissions
RUN chmod o-rwx -R /run/php && \
	chmod o-rwx -R /var/www/html &&\
	chmod o-rwx -R /etc/php/7.3/fpm/pool.d/ &&\
	chmod o-rwx -R /var/www/html && \
	chmod o-rwx /usr/local/bin/wp &&\
	chmod u+x /usr/local/bin/wp &&\
	chmod u+r -R /etc/php/7.3/fpm/pool.d &&\
	chmod u+x /var/www/html/wp_setup.sh

WORKDIR /var/www/html

USER wordpress

EXPOSE 9000

ENTRYPOINT ["sh", "./wp_setup.sh"]
