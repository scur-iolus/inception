green() {
	echo "\e[32m${1}\e[0m"
}

green "✅ Nginx has been successfully installed\n"

# x509 -> generates a self certificate
# subj -> replaces subject field of input request with specified data
# nodes -> the newly created private key won't be encrypted
# sha256 -> uses the SHA-256 signature algorithm
openssl req -newkey rsa:4096 -x509 -sha256 -days 90 -nodes \
	-out /etc/ssl/nginx/$DOMAIN_NAME.pem -keyout /etc/ssl/nginx/$DOMAIN_NAME.key \
	-subj "/C=FR/ST=Paris/L=Paris/O=42 Paris/OU=$ADMIN_NAME/CN=$DOMAIN_NAME" &> /dev/null

echo "⏳ Waiting for openssl...\n" && sleep 2
until [ -f "/etc/ssl/nginx/$DOMAIN_NAME.key" ];
do
	echo "⏳ Waiting for openssl...\n" && sleep 2
done

chown -R www-data:www-data /etc/ssl/nginx
chmod -R 600 /etc/ssl/nginx

green "✅ Self certificate generated, permissions updated\n"

sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/conf.d/my_server.conf

# The option prevents the container from halting
# since Docker is only watching the PID of the original command
green "🚀 Launching nginx...\n"
/usr/sbin/nginx -g 'daemon off;'
