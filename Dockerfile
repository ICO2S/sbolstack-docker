# This file can be used to create a Docker image of the sbol-stack components.
# To use, run "docker build"
#
# Keith Flanagan
# 2016-04-24: version 1.0

FROM ubuntu:16.04
MAINTAINER Keith Flanagan <k.s.flanagan@gmail.com>

# Dependencies
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y \
	git \
	nodejs \
	npm \
	openjdk-8-jre-headless \
    && update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Create a new user to run the processes
RUN useradd ubuntu -p ubuntu -m -s /bin/bash


# Copy in our own custom Tomcat (I prefer this to the packaged version)
# Install the appropriate bits of openrdf-sesame
ADD apache-tomcat-8.0.33.tar.gz /opt/
COPY openrdf-sesame.war /opt/apache-tomcat-8.0.33/webapps/
RUN chown -R ubuntu:ubuntu /opt/apache-tomcat-8.0.33


# Check out a specific tagged revision of the stack API
# Note that --branch here actually refers to a tag (git weirdness...) 
RUN cd /opt && git clone https://github.com/ICO2S/sbolstack-api.git --depth 1 --branch v1.0
RUN cd /opt/sbolstack-api && npm install && npm install -g forever
RUN chown -R ubuntu:ubuntu /opt/sbolstack-api


# Convenience script for starting both Tomcat and node
COPY startup.sh /
RUN chmod +x /startup.sh


# Informs docker that the container will listen on these ports
# This does NOT expose these ports on the host (for which you need -p at runtime)
EXPOSE 9090

# Store the SBOL stack config directory within a volume to allow user modifications
# Store the Sesame data directory in an external volume for persistence
# First, we need to make the directory and have it owned by the right user
#    See: http://stackoverflow.com/questions/26145351/why-doesnt-chown-work-in-dockerfile
RUN mkdir /home/ubuntu/.aduna \
	&& chown ubuntu:ubuntu /home/ubuntu/.aduna
VOLUME ["/opt/sbolstack-api/config", "/home/ubuntu/.aduna"]


ENTRYPOINT ["/startup.sh"]


