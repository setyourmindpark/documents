FROM setyourmindpark/debian-oracle-jdk:8
MAINTAINER jaehunpark "setyourmindpark@gmail.com"

ENV HOME=/root
ENV TOMCAT_VERSION=7.0.82
ENV CATALINA_HOME=${HOME}/tomcat

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y curl && \
    apt-get install -y wget

RUN wget --quiet --no-cookies http://apache.tt.co.kr/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz && \
    tar xzvf /tmp/tomcat.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm /tmp/tomcat.tar.gz

RUN mkdir /var/origin && \
    cp -r ${CATALINA_HOME} /var/origin

ADD entrypoint.sh /entrypoint.sh

VOLUME ${HOME}

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
