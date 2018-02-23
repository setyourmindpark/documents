#!/bin/sh
if [ ! -d "$HOME/tomcat" ]; then
    echo '[ not exsist $HOME/tomcat. so copy from /var/origin/tomcat to $HOME ]'
    cp -r /var/origin/tomcat $HOME
  else
    echo '[ exsist $HOME/tomcat. nothing to do ]'
fi

if [ ! -d "$HOME/maven" ]; then
    echo '[ not exsist $HOME/maven. so copy from /var/origin/maven to $HOME ]'
    cp -r /var/origin/maven $HOME
  else
    echo '[ exsist $HOME/maven. nothing to do ]'
fi

if [ ! -d "$HOME/.nvm" ]; then
    echo '[ not exsist $HOME/.nvm. so copy from /var/origin/.nvm to $HOME ]'
    cp -r /var/origin/.nvm $HOME
  else
    echo '[ exsist $HOME/.nvm. nothing to do ]'
fi

if [ ! -f "$HOME/.bashrc" ]; then
    echo '[ not exsist $HOME/.bashrc. so copy from /var/origin/.bashrc to $HOME ]'
    cp /var/origin/.bashrc $HOME
  else
    echo '[ exsist $HOME/.bashrc. nothing to do ]'
fi

service docker start
. $HOME/.bashrc
./$HOME/tomcat/bin/catalina.sh run