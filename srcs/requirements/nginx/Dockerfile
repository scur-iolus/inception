FROM debian:buster

# to avoid debian harmless warnings
ARG DEBIAN_FRONTEND=teletype

# cleaning up the apt cache after upgrade to keep the image size down
RUN apt-get -q -y update &&\
	apt-get -q -y install nginx &&\
	apt-get -q -y install openssl &&\
	rm -rf /var/lib/apt/lists/*

# customization of the nginx user and group ids in the image
# 33 is the user id and group id for www-data on Ubuntu & Debian by default
ARG nginx_uid=1000
ARG nginx_gid=1000

# worker processes will run as the user nginx with group nginx
# to this end, we'll override their respective uid and guid to something
# else that lines up better with file permissions,
# the -o switch allows reusing an existing user id
RUN usermod -u $nginx_uid -o www-data && groupmod -g $nginx_gid -o www-data

# adds the access rights to the files for nginx logs, removes default welcome page
RUN rm -rf /var/log/nginx &&\
	mkdir /var/log/nginx &&\
	touch /var/log/nginx/access.log &&\
	touch /var/log/nginx/error.log &&\
	mkdir /etc/ssl/nginx &&\
	chown -R www-data:www-data /var/log/nginx &&\
	rm /var/www/html/index.nginx-debian.html

# the conf.d folder gathers files that are included at the end of nginx.conf
COPY ./utils/my_server.conf /etc/nginx/conf.d

COPY ./utils/setup.sh /etc/nginx/nginx_setup.sh

WORKDIR /var/www/html

EXPOSE 443

ENTRYPOINT [ "sh", "/etc/nginx/nginx_setup.sh" ]
