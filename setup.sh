#!/bin/bash

# Add user to password less sudo
# echo $USER' ALL=(ALL) NOPASSWD:ALL' >> sudo visudo

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y git

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


