#!/bin/bash

# Starts Tomcat, and then the stack.
su ubuntu -c "/opt/apache-tomcat-8.0.33/bin/startup.sh"

# Ugly hack applied to allow Tomcat to start up, before the sbol stack queries it
echo "Please wait ..."
sleep 15

cd /opt/sbolstack-api/ && su ubuntu -c "forever server.js" & 

# A hack to keep the Docker image alive, since the above are forked
tail -f /dev/null

