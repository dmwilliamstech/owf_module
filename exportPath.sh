#!/bin/sh

echo 'export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64' >> /home/vagrant/.bashrc
echo 'export GROOVY_HOME=/opt/groovy-1.8.9' >> /home/vagrant/.bashrc
echo 'export GRAILS_HOME=/home/vagrant/grails-1.3.7' >> /home/vagrant/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$GRAILS_HOME/bin:$PATH:$GROOVY_HOME/bin:$PATH' >> /home/vagrant/.bashrc
source ~/.bashrc
exit 0
