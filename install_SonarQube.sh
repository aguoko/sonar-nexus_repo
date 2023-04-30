https://github.com/jae1choi/sonaqueue-installation-guide

#Update your server.
sudo apt update
sudo apt upgrade -y

#Install OpenJDK 11.
sudo apt install -y openjdk-11-jdk

#Install and Configure PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'


#Add PostgreSQL signing key.

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

#Install PostgreSQL.
sudo apt install -y postgresql postgresql-contrib

#Enable DB server to start automatically on reboot.
sudo systemctl enable postgresql

#Start DB server.

sudo systemctl start postgresql

#Change the default PostgreSQL password.
sudo passwd postgres

#Switch to the postgres user.
sudo su - postgres

#Create a user named sonar.
createuser sonar

#Log into PostgreSQL.

psql

#Set a password for the sonar user. Use a strong password in place of my_strong_password.
ALTER USER sonar WITH ENCRYPTED password 'sonar';

#Create SonarQube database and set its owner to sonar.
CREATE DATABASE sonarqube OWNER sonar;

#Grant all privileges on SonarQube database to the user sonar.

GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;

# Exit PostgreSQL.

\q

#Return to your non-root sudo user account.

exit


#Download and Install SonarQube,Install the zip utility, which is needed to unzip the SonarQube files.
sudo apt install zip -y

#Install SonarQube
https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip

#Download the SonarQube distribution files.

sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip

#Unzip the downloaded file.

sudo unzip sonarqube-9.0.1.46107.zip

#Move the unzipped files to /opt/sonarqube directory

sudo mv sonarqube-9.0.1.46107 /opt/sonarqube

#Add SonarQube Group and User

#Create a sonar group.

sudo groupadd sonar

#Create a sonar user and set /opt/sonarqube as the home directory.

sudo useradd -d /opt/sonarqube -g sonar sonar

#Grant the sonar user access to the /opt/sonarqube directory.

sudo chown sonar:sonar /opt/sonarqube -R

#Configure SonarQube

#Edit the SonarQube configuration file.

sudo nano /opt/sonarqube/conf/sonar.properties

# Uncomment and Type the PostgreSQL Database username and password which we have created in above steps and add the postgres connection string. 


sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube


#Edit the sonar script file and set RUN_AS_USER 
sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh

#Uncomment the line RUN_AS_USER= and change it to.

RUN_AS_USER=sonar

#Create a systemd service file to start SonarQube at system boot.

sudo nano /etc/systemd/system/sonar.service

Paste the following lines to the file:

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target


#Enable the SonarQube service to run at system startup.
sudo systemctl enable sonar

#Start the SonarQube service.
sudo systemctl start sonar

#Check the service status.
sudo systemctl status sonar

#Modify/Edit Kernel System Limits, SonarQube uses Elasticsearch to store its indices in an MMap FS directory. It requires some changes to the system defaults.

sudo nano /etc/sysctl.conf

#Add the following lines.:

vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

# Reboot the system to apply the changes.
sudo reboot


