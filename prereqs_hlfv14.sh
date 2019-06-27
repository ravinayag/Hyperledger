#!/bin/sh

### export environment variables for current shell.
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=${PWD}/bin:${PWD}:$PATH

#### adding  environment variables to profile
echo 'export GOPATH=/opt/go' >> ~/.profile
echo 'export GOBIN=/opt/go/bin' >> ~/.profile
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.profile
echo 'export PATH=${PWD}/bin:${PWD}:$PATH' >> ~/.profile
source ~/.profile

#### Installing dependency packages 
sudo apt-get install -y curl golang-go
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-get install python
sudo apt-get update -y
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce docker-ce-cli
sudo curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo cp /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh && sudo apt-get install -y nodejs 
sudo apt-get install -y build-essential checkinstall libssl-dev
sudo apt-get upgrade -y


##### Add user account to the docker group
sudo usermod -aG docker $(whoami)

####  Print installation details for user
echo ''
echo 'Installation completed, versions installed are:'
echo ''
echo -n 'Node:           '
node --version
echo -n 'npm:            '
npm --version
echo -n 'Docker:         '
docker --version
echo -n 'Docker Compose: '
docker-compose --version
echo -n 'Python:         '
python -V

echo " Logout/login back for the changes to take effect."
