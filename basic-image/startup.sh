#!/bin/bash

# Create an empty directory for Sesame if one doesn't exist already.
# Create a default stack config, if one doesn't exist already.

if ! [ -d "/mnt/data/aduna" ] ; then
  mkdir /mnt/data/aduna
fi

if ! [ -d "/mnt/data/stack-config" ] ; then
  mkdir /mnt/data/stack-config
fi

if ! [ -e "/mnt/data/stack-config/default.json" ] ; then
  cp /opt/sbolstack-api/example-config.json /mnt/data/stack-config/default.json
fi


# In any case, make sure that everything is writable by Sesame/Stack
chown -R ubuntu:ubuntu /mnt/data 

# Starts Tomcat, and then the stack.
su ubuntu -c "/opt/apache-tomcat-8.0.33/bin/startup.sh"

# Ugly hack applied to allow Tomcat to start up, before the sbol stack queries it
echo "Please wait ..."
sleep 15

cd /opt/sbolstack-api/ && su ubuntu -c "forever server.js" & 

# A hack to keep the Docker image alive, since the above are forked
tail -f /dev/null

