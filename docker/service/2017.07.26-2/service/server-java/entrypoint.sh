#!/bin/sh
if [ ! -d "$HOME/tomcat" ]; then
    echo '[ not exsist $HOME/tomcat. so copy from /var/origin/tomcat to $HOME ]'
    cp -r /var/origin/tomcat $HOME
  else
    echo '[ exsist $HOME/tomcat. nothing to do ]'
fi

./$HOME/tomcat/bin/catalina.sh run
