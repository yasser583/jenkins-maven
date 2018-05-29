# Installing Docker
curl https://get.docker.com | sh
systemctl start docker
systemctl enable docker
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Installing Java 8 Oracle
add-apt-repository ppa:webupd8team/java
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer

# Installing Maven
apt-get install -y maven

#Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo 'deb https://pkg.jenkins.io/debian-stable binary/' | tee -a /etc/apt/sources.list
apt-get update
apt-get install -y jenkins
systemctl start jenkins
systemctl enable jenkins

#Jenkins user

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
JENKINS_USER=jenkins

if [ -S ${DOCKER_SOCKET} ]; then
  DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
  groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
  usermod -aG ${DOCKER_GROUP} ${JENKINS_USER}
fi

sudo usermod -a -G docker jenkins
sh -c "echo 'jenkins ALL=NOPASSWD: ALL' >> /etc/sudoers"
systemctl restart jenkins

# Install Tomcat
apt-get install -y tomcat8

# Iniciando portainer
docker-compose up -d

echo 'Recuerda cambiar el puerto de Tomcat en /etc/tomcat8/server.xml'