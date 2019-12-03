#!/bin/bash

# Add user to password less sudo
echo $USER' ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers > /dev/null

sudo apt update -y
sudo apt upgrade -y

# Add swap file
sudo fallocate -l 8G /mnt/8GB.swap
sudo mkswap /mnt/8GB.swap
sudo swapon /mnt/8GB.swap
echo '/mnt/8GB.swap  none  swap  sw 0  0' | sudo tee -a /etc/fstab > /dev/null

sudo apt install -y git


sudo apt install python3    
#Setup Python3 as the default 
sudo ln -fs /usr/bin/python3 /usr/bin/python
sudo apt install -y python3-pip
pip3 --version
pip3 install numpy

#Check Python, OpenCV version
python -c '\
import sys; \
import cv2; \
print("python version {0}, cv2 version: {1}".format(sys.version, cv2.__version__)); \
print(cv2.getBuildInformation())'

# Setup git
git config --global credential.helper store
git config --global user.name "shankar-roy"
read -sp 'github Password: ' passvar
git config --global user.password $passvar
git config --global user.email "shankar.roy@gmail.com"

# Setup cuda
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

# Install OpenCV Source
opencv_ver=3.4.8
wget https://github.com/opencv/opencv/archive/$opencv_ver.zip -O opencv.zip
wget https://github.com/opencv/opencv_contrib/archive/$opencv_ver.zip -O opencv_contrib.zip


