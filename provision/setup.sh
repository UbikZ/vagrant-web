#!/bin/bash

echo "Update Machine"
apt-get update -y >/dev/null

echo "Install tools"
apt-get install curl debconf-utils -y >/dev/

echo "Installing openssh-server"

echo "Installing Git"
apt-get install git -y >/dev/null


echo "Installing PHP"
apt-get install php5-common php5-dev php5-cli -y >/dev/null

echo "Installing PHP extensions"
apt-get install php5-curl php5-intl php5-gd php5-mcrypt php5-mysql -y >/dev/null

echo "Preparing MySQL"
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "Installing MySQL"
apt-get install mysql-server -y >/dev/null

echo "Installing Mongo"
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 >/dev/null
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
apt-get update >/dev/null
sudo apt-get install -y mongodb-org >/dev/null
/etc/init.d/mongod restart

echo "Installing Nginx"
apt-get install nginx -y >/dev/null
/etc/init.d/nginx stop

echo "Configuring Nginx"
cp /vagrant/provision/config/nginx/generic /etc/nginx/sites-available/generic >/dev/null
[ ! -h /etc/nginx/sites-enabled/generic ] && ln -s /etc/nginx/sites-available/generic /etc/nginx/sites-enabled/generic
rm -rf /etc/nginx/sites-available/default

echo "Start nginx"
/etc/init.d/nginx start >/dev/null

echo "Installing Apache"
apt-get install apache2 -y >/dev/null
/etc/init.d/apache2 stop

echo "Configuring Apache"
cp /vagrant/provision/config/apache/000-default.conf /etc/apache2/sites-available/000-default
cp /vagrant/provision/config/apache/ports.conf /etc/apache2/ports.conf
a2enmod rewrite

echo "Start apache"
/etc/init.d/apache2 start >/dev/null

echo "Install composer"
curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

echo "Install node"
curl -sL https://deb.nodesource.com/setup_5.x | bash -
apt-get install -y nodejs
[ ! -h /usr/bin/node ] && ln -s /usr/bin/nodejs /usr/bin/node
npm install gulp-cli pm2 -g

echo "Clean"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
