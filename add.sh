#!/bin/bash

# add user u
useradd                 \
    --shell /bin/bash   \
    --create-home       \
    u
usermod                 \
    --append            \
    --groups sudo       \
    u
cp -r ~/.ssh /home/u/
chown -R u:u /home/u/.ssh
sed -ie 's/#PasswordAuthentication\syes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ie 's/UsePAM\syes/UsePAM no/g' /etc/ssh/sshd_config

# docker-ce
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
sudo groupadd docker
sudo usermod -aG docker u

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# docker-machine
sudo curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
    chmod +x /tmp/docker-machine && \
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
    
# Unattended upgrades
apt-get install -y unattended-upgrades apt-listchanges
apt upgrade -y

# nvim
sudo apt-get install -y neovim

# tmux
sudo apt-get install -y tmux

# node
sudo apt-get install -y nodejs
sudo apt-get install -y npm

# as user from here:
function wS() { sudo -iu u bash -c "$@"; }
wS 'mkdir $HOME/.config'
wS 'git clone https://github.com/2jj/nvim.git $HOME/.config/nvim'
wS 'ln -sf $HOME/.config/nvim/.bash_aliases $HOME/.bash_aliases'
wS 'ln -sf $HOME/.config/nvim/.tmux.conf $HOME/.tmux.conf'
wS 'npm i -g yarn'
