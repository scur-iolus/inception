FROM debian:buster

# cleaning up the apt cache after upgrade to keep the image size down
RUN apt-get -y update &&\
	apt-get -y install nginx &&\
	rm -rf /var/lib/apt/lists/*

# customization of the nginx user and group ids in the image
# we'll use 33 which is the user id and group id for www-data on Ubuntu & Debian
ARG nginx_uid=33
ARG nginx_gid=33

# worker processes will run as the user nginx with group nginx
# to this end, we'll override their respective uid and guid to something
# else that lines up better with file permissions,
# the -o switch allows reusing an existing user id
RUN usermod -u $nginx_uid -o www-data && groupmod -g $nginx_gid -o www-data

# adds the access rights to the files for nginx logs
RUN rm -rf /var/log/nginx &&\
	mkdir /var/log/nginx &&\
	touch /var/log/nginx/access.log &&\
	touch /var/log/nginx/error.log &&\
	chown -R www-data:www-data /var/log/nginx

# Generate a self certificate # FIXME
# RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/llalba.42.fr.pem -keyout /etc/ssl/llalba.42.fr.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=llalba/CN=llalba.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
# EXPOSE 443/tcp # FIXME

# The option prevents the container from halting
# since Docker is only watching the PID of the original command
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
