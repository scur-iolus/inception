FROM debian:buster

# cleaning up the apt cache after upgrade to keep the image size down
RUN apt-get -y update && \
	apt-get -y install wordpress && \
	apt-get -y install php-fpm && \
	rm -rf /var/lib/apt/lists/*

RUN useradd -gs /bin/bash -u 999 blog

USER blog

https://howto.wared.fr/installation-wordpress-ubuntu-nginx/
