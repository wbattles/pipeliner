#!/bin/bash

sudo apt update

sudo apt-get install nginx -y
sudo systemctl status nginx

echo 'server {
  listen 80;
  location / {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}' | sudo tee /etc/nginx/sites-available/default

sudo nginx -t
sudo systemctl restart nginx

sudo apt-get install docker.io -y
sudo systemctl start docker

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install -y unzip
unzip -o -q awscliv2.zip
sudo ./aws/install --update

aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com


sudo kill -9 $(sudo lsof -ti:8000) || true

CONTAINER_ID=$(sudo docker ps -q --filter "publish=8000")
if [ ! -z "$CONTAINER_ID" ]; then
    sudo docker stop $CONTAINER_ID
    sudo docker rm $CONTAINER_ID
fi

sudo netstat -tuln | grep :8000 && sudo fuser -k 8000/tcp || true
sudo docker system prune -f

sudo docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ECR_REPOSITORY:latest
sudo docker run -d \
  -p 8000:8000 \
  --env AWS_EC2_METADATA_DISABLED=false \
  --name run_app \
  --network host \
  $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ECR_REPOSITORY:latest