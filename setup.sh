#!/bin/bash

if [ "$1" == "start" ]; then
    sudo docker-compose start
fi

if [ "$1" == "stop" ]; then
    sudo docker-compose stop
fi

if [ "$1" == "delete" ]; then
    sudo docker-compose -f docker-compose.prod.yml stop
    docker rm -f ghost-prod ghost-prod-caddy ghost-prod-db
fi

if [ "$1" == "update" ]; then    
    sudo docker-compose pull && sudo docker-compose up -d && sudo docker image prune -f
fi

if [ "$1" == "setup" ]; then
  echo 'Cloning repo....' 
  rm -rf ghost; git clone https://github.com/Alt-Ghost/altghost-devops
  cd altghost-devops 
  git checkout ghost-caddy
  echo 'Adding domain ...'
  sed -i "s/<domain>/$2/g" Caddyfile 
  sed -i "s/<domain>/$2/g" docker-compose.prod.yml 
  echo 'Installing Docker...' 
  sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y 
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y 
  sudo apt update -y 
  sudo apt install docker-ce docker-ce-cli containerd.io -y 
  echo 'Installing Docker Compose...' 
  COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4) 
  sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
  sudo chmod +x /usr/local/bin/docker-compose 
  echo 'Building Docker ....'
  docker-compose -f docker-compose.prod.yml up -d --build 
  #  echo 'Access your ghost: https://'$2;
  # echo 'Access your ghost admin page: https://'$2'/ghost';

fi