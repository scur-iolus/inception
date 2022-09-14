FROM debian:buster

# cleaning up the apt cache after upgrade to keep the image size down
RUN apt-get -y update && apt-get -y install nginx && \
	rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443/tcp

# The option prevents the container from halting
# since Docker is only watching the PID of the original command
CMD ["/usr/sbin/nginx", "-g", "daemon off"]
