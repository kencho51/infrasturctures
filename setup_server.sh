#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# Install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/ubuntu/miniconda.sh && \
bash /home/ubuntu/miniconda.sh -u -b -p /home/ubuntu/miniconda3 && \
echo 'export PATH="/home/ubuntu/miniconda3/bin:$PATH"' >> /home/ubuntu/.bashrc && \
rm -rf /home/ubuntu/miniconda.sh