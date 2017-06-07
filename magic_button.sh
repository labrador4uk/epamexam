#!/bin/sh

                                 echo " --- Script started ---"

sleep 3



                                 echo " --- Installing NGINX --- "



sleep 3
sudo apt update
sudo apt -y install nginx
sudo systemctl start nginx




                                 echo " --- Check NGINX status --- "



systemctl status nginx | grep Active:
sleep 3



                                 echo " --- Installing MySQL --- "



sleep 3
 echo mysql-server mysql-server/root_password password 1234 | sudo debconf-set-selections
 echo mysql-server mysql-server/root_password_again password 1234 | sudo debconf-set-selections 
 sudo apt -y install mysql-server



                                echo " --- Installing Confluence --- "



sleep 3


mkdir confluence
cp ./response.varfile ./confluence
cd confluence
wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.1.4-x64.bin
chmod a+x atlassian-confluence-6.1.4-x64.bin
sudo ./atlassian-confluence-6.1.4-x64.bin -q -varfile response.varfile

cd ..


                                 echo " --- Configuring MySQL --- "



sleep 3
sudo cat ./SQLCFG >> /etc/mysql/my.cnf

mysql -u root -p1234 <<MYSQL_SCRIPT

CREATE DATABASE confluence CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON confluence.* TO 'admin'@'localhost' IDENTIFIED BY '1234';

MYSQL_SCRIPT

sudo service mysql restart

                       echo " --- Installing MySQL driver for Confluence --- "



sleep 3
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz
tar -xvf mysql-connector-java-5.1.42.tar.gz &
sudo cp ./mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar /opt/atlassian/confluence/confluence/WEB-INF/lib




                                echo " --- Check MySQL status --- "



sudo systemctl status mysql | grep Active:
sleep 3



                                echo " --- Configuring Tomcat --- "



sleep 3

sudo /opt/atlassian/confluence/bin/stop-confluence.sh

sudo cp ./server.xml /opt/atlassian/confluence/conf

sudo cp ./web.xml /opt/atlassian/confluence/confluence/WEB-INF

sudo /opt/atlassian/confluence/bin/start-confluence.sh



                                 echo " --- Configuring SSL --- "



sleep 3
                                
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=UA/ST=Lviv/L=Lviv/O=EPAMLab/OU=Epamstudent/CN=192.168.56.111/emailAddress=labradortunngle@gmail.com"

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 
 

echo "-----Below is your Certificate-----"

cat /etc/ssl/certs/nginx-selfsigned.crt

sleep 3
 
echo "-----Below is your Key-----"

cat /etc/ssl/private/nginx-selfsigned.key

sleep 3

sudo service nginx stop

cat ./default > /etc/nginx/sites-available/default

sudo service nginx start



