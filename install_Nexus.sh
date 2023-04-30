# Mininium CPU 4, update the system packages

sudo apt-get update

#1: Install OpenJDK 1.8 on Ubuntu 20.04 LTS
sudo apt install openjdk-8-jre-headless -y

#2: Download Nexus Repository Manager setup on Ubuntu 20.04 LTS; Navigate to /opt directory

cd /opt

#Download the SonaType Nexus on Ubuntu using wget
sudo wget https://download.sonatype.com/nexus/3/nexus-3.52.0-01-unix.tar.gz

#3: Install Nexus Repository on Ubuntu 20.04 LTS; Extract the Nexus repository setup in /opt directory
sudo tar -zxvf nexus-3.52.0-01-unix.tar.gz

#4 Rename the extracted Nexus setup folder to nexus
sudo mv /opt/nexus-3.52.0-01 /opt/nexus

#5: As security practice, not to run nexus service using root user, so lets create new user named nexus to run nexus service
sudo adduser nexus

#6 To set no password for nexus user open the visudo file in ubuntu
sudo visudo

#7 Add below line into it , save and exit
nexus ALL=(ALL) NOPASSWD: ALL

#8 Give permission to nexus files and nexus directory to nexus user
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

#9 To run nexus as service at boot time, open /opt/nexus/bin/nexus.rc file, uncomment it and add nexus user as shown below

sudo vim /opt/nexus/bin/nexus.rc
run_as_user="nexus"

#10 To Increase the nexus JVM heap size, open the /opt/nexus/bin/nexus.vmoptions file, you can modify the size as shown below

sudo vim /opt/nexus/bin/nexus.vmoptions

#11 To run nexus as service using Systemd
sudo vim /etc/systemd/system/nexus.service

paste the below lines into it:

[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target


sudo systemctl start nexus
sudo systemctl enable nexus
sudo systemctl status nexus
