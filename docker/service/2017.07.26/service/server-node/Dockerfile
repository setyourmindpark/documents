FROM setyourmindpark/debian-node:7
MAINTAINER jaehunpark "setyourmindpark@gmail.com"

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y python-software-properties && \
    apt-get install -y python && \
    apt-get install -y g++ && \
    apt-get install -y make && \
    apt-get install -y openssh-server && \
    npm install -y pm2 -g && \
    mkdir /var/run/sshd

EXPOSE 22
EXPOSE 4000
VOLUME /root

CMD ["/usr/sbin/sshd","-D"]
