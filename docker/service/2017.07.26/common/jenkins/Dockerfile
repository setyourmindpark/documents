FROM setyourmindpark/debian-oracle-jdk:8
MAINTAINER jaehunpark "setyourmindpark@gmail.com"

ENV HOME=/root
ENV TOMCAT_VERSION=8.5.16
ENV MAVEN_VERSION=3.5.0
ENV NVM_VERSION=v0.33.2
ENV CATALINA_HOME=${HOME}/tomcat
ENV MAVEN_HOME=${HOME}/maven

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y git-core && \
    apt-get install -y curl && \
    apt-get install wget

# Get Tomcat
RUN wget --quiet --no-cookies http://apache.tt.co.kr/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz && \
    tar xzvf /tmp/tomcat.tar.gz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm /tmp/tomcat.tar.gz

# jenkins download
RUN wget --quiet --no-cookies http://mirrors.jenkins.io/war-stable/latest/jenkins.war -O ${CATALINA_HOME}/webapps/jenkins.war
#RUN wget --quiet --no-cookies http://mirrors.jenkins.io/war-stable/2.7.2/jenkins.war -O ${CATALINA_HOME}/webapps/jenkins.war

RUN wget --quiet --no-cookies http://apache.tt.co.kr/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar xzvf /tmp/maven.tar.gz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    rm /tmp/maven.tar.gz

ENV PATH=${PATH}:${MAVEN_HOME}/bin

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ${HOME}/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ${HOME}/.bashrc

RUN mkdir /var/origin && \
    cp -r ${CATALINA_HOME} /var/origin && \
    cp -r ${MAVEN_HOME} /var/origin && \
    cp -r ${HOME}/.nvm /var/origin && \
    cp ${HOME}/.bashrc /var/origin

ADD entrypoint.sh /var/origin/entrypoint.sh

VOLUME ${HOME}

EXPOSE 8080

ENTRYPOINT ["/var/origin/entrypoint.sh"]
