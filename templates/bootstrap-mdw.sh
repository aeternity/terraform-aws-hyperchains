#!/bin/bash
# Don't enable debug mode in this script if secrets are managed as it ends-up in the logs
set -eo pipefail

# Wait for an Elastic IP address to be associated
sleep 10

exec > >(tee /tmp/user-data.log|logger -t user-data ) 2>&1

bash <(curl -s https://raw.githubusercontent.com/aeternity/infra-node-aws-bootstrap/master/bootstrap.sh)

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker engine
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

getent group docker || sudo groupadd docker
sudo usermod -aG docker master
sudo usermod -aG docker aeternity
sudo usermod -aG docker ubuntu

sudo cp /home/aeternity/node/aeternity.yaml /home/ubuntu/
sudo mkdir -p /data/db1/mnesia
sudo mkdir -p /data/db1/mdw.db
sudo mkdir -p /data/log
sudo chown -R ubuntu:ubuntu /data
sudo chown ubuntu:ubuntu /home/ubuntu/aeternity.yaml

sudo /home/aeternity/node/bin/aeternity stop

sudo -u ubuntu docker pull aeternity/ae_mdw:latest
sudo -u ubuntu docker start aemdw || sudo -u ubuntu docker run -d --name aemdw --user 1000:1000 \
    -p 4000:4000 -p 4001:4001 -p 3013:3013 -p 3113:3113 -p 3014:3014 \
    -e AETERNITY_CONFIG=/home/aeternity/aeternity.yaml \
    -e AE__CHAIN__DB_PATH=/home/aeternity/node/local/rel/aeternity/data/mnesia \
    -v /data/db1/mnesia:/home/aeternity/node/local/rel/aeternity/data/mnesia \
    -v /data/db1/mdw.db:/home/aeternity/node/local/rel/aeternity/data/mdw.db \
    -v /data/log:/home/aeternity/node/ae_mdw/log \
    -v /home/ubuntu/accounts.json:/home/aeternity/node/local/rel/aeternity/data/aecore/.genesis/accounts_test.json \
    -v /home/ubuntu/aeternity.yaml:/home/aeternity/aeternity.yaml \
    aeternity/ae_mdw:latest

sudo -u ubuntu docker start aemdw || sudo -u ubuntu docker run -d --name aemdw --user 1000:1000 \
    -p 4000:4000 -p 4001:4001 -p 3013:3013 -p 3113:3113 -p 3014:3014 \
    -e AETERNITY_CONFIG=/home/aeternity/aeternity.yaml \
    -e AE__CHAIN__DB_PATH=/home/aeternity/node/local/rel/aeternity/data/mnesia \
    -v /data/db1/mnesia:/home/aeternity/node/local/rel/aeternity/data/mnesia \
    -v /data/db1/mdw.db:/home/aeternity/node/local/rel/aeternity/data/mdw.db \
    -v /data/log:/home/aeternity/node/ae_mdw/log \
    -v /home/ubuntu/accounts.json:/home/aeternity/node/local/rel/aeternity/data/aecore/.iris/aehc_demo_accounts.json \
    -v /home/ubuntu/contracts.json:/home/aeternity/node/local/rel/aeternity/data/aecore/.iris/aehc_demo_contracts.json \
    -v /home/ubuntu/aeternity.yaml:/home/aeternity/aeternity.yaml \
    aeternity/ae_mdw:latest
