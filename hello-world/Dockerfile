# A Docker image of the sbol stack, populated with a number of demo components.
#
# Keith Flanagan
# 2016-04-24: version 1.0

FROM keithf/sbolstack:2016-04-25
MAINTAINER Keith Flanagan <k.s.flanagan@gmail.com>


ADD aduna-29-components.tar.gz /home/ubuntu
RUN chown -R ubuntu:ubuntu /home/ubuntu/.aduna


ENTRYPOINT ["/startup.sh"]


