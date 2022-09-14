FROM debian:buster

# cleaning up the apt cache after upgrade to keep the image size down
RUN apt-get -y update && \
	apt-get -y install wordpress && \
	apt-get -y install php-fpm && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /var/blog/html/

COPY ./conf/blog.conf .

EXPOSE 9000
