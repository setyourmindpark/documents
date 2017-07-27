FROM setyourmindpark/debian-oracle-jdk:8
MAINTAINER jaehunpark "setyourmindpark@gmail.com"

ENV HOME=/root
ENV TOMCAT_VERSION=8.5.16
ENV MAVEN_VERSION=3.5.0
ENV CATALINA_HOME=${HOME}/tomcat
ENV MAVEN_HOME=${HOME}/maven

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y curl && \
    apt-get install -y wget

# Get Tomcat
RUN wget --quiet --no-cookies http://apache.tt.co.kr/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz && \
    tar xzvf /tmp/tomcat.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm /tmp/tomcat.tar.gz

RUN wget --quiet --no-cookies http://apache.tt.co.kr/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar xzvf /tmp/maven.tar.gz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    rm /tmp/maven.tar.gz

ENV PATH=${PATH}:${MAVEN_HOME}/bin

RUN mkdir /var/origin && \
    cp -r ${CATALINA_HOME} /var/origin && \
    cp -r ${MAVEN_HOME} /var/origin

ADD entrypoint.sh /entrypoint.sh

VOLUME ${HOME}

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
