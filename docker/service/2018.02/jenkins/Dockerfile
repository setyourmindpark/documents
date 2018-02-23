FROM setyourmindpark/debian-oracle-jdk:8
MAINTAINER jaehunpark "setyourmindpark@gmail.com"

ENV HOME=/root
ENV TOMCAT_VERSION=8.5.28
ENV MAVEN_VERSION=3.5.2
ENV NVM_VERSION=v0.33.8
ENV CATALINA_HOME=${HOME}/tomcat
ENV MAVEN_HOME=${HOME}/maven

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y python-software-properties && \
    apt-get install -y python && \
    apt-get install -y g++ && \
    apt-get install -y make && \
    apt-get install -y vim && \
    apt-get install -y git-core && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y jq

# install docker ( to control docker in jenkins )
RUN apt-get install -y apt-transport-https && \
    apt-get install -y ca-certificates && \
    apt-get install -y gnupg2 && \
    apt-get install -y software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get install -y docker-ce

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

ADD entrypoint.sh /entrypoint.sh

VOLUME ${HOME}

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]

