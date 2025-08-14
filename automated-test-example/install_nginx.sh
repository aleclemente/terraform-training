#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
public_ip=$(curl http://checkip.amazonaws.com/)
echo "
<html>
<head><title>Hello from Nginx!</title></head>
<body><h1>Hello from Nginx!</h1>
<p>Your public IP is: $public_ip</p>
</body>
</html>" | tee /usr/share/nginx/html/index.html > /dev/null
systemctl restart nginx