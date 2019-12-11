#!/bin/bash

# Add user to password less sudo
echo $USER' ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers > /dev/null

# Update package manager
sudo apt update -y
sudo apt upgrade -y

# Add swap file
sudo fallocate -l 8G /mnt/8GB.swap
sudo mkswap /mnt/8GB.swap
sudo swapon /mnt/8GB.swap
echo '/mnt/8GB.swap  none  swap  sw 0  0' | sudo tee -a /etc/fstab > /dev/null

sudo apt install -y git
git config --global user.name "Shankar Roy"
git config --global user.email "shankar.roy@gmail.com"

sudo apt install python3    
#Setup Python3 as the default 
sudo ln -fs /usr/bin/python3 /usr/bin/python

# Install Pip package manager
sudo apt install -y python3-pip
pip3 --version
pip3 install numpy

# Install jetson-stats
sudo -H pip install jetson-stats
# Print info about jetson
jetson_release

#Make sure CUDA is in your PATH! 
echo 'export PATH=${PATH}:/usr/local/cuda/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64' >> ~/.bashrc
source .bashrc
# Verify, this command should work now
nvcc --version

# Output should be something like:
# - NVIDIA Jetson TX2
#  * Jetpack 4.2 [L4T 32.1.0]
#  * CUDA GPU architecture 6.2
#  * NV Power Mode: MAXN - Type: 0

# Output should be something like:
# - NVIDIA Jetson TX2
#  * Jetpack 4.2 [L4T 32.1.0]
#  * CUDA GPU architecture 6.2
#  * NV Power Mode: MAXN - Type: 0


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

unzip opencv.zip
unzip opencv_contrib.zip

mv opencv-$opencv_ver opencv
mv opencv_contrib-$opencv_ver opencv_contrib

# Dependency forcompiling OpenCV
sudo apt-get install -y build-essential cmake unzip pkg-config
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libjasper-dev
# If missing do the following
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
sudo apt update
sudo apt install libjasper1 libjasper-dev
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
sudo apt update
sudo apt install -y libjasper1 libjasper-dev

sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev

sudo apt-get install -y libgtk-3-dev
sudo apt-get install -y libatlas-base-dev gfortran

# To compile OpenCV with gstreamer we will need the following
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

cd ~/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_GSTREAMER=ON \
    -D BUILD_EXAMPLES=ON ..

make ${nproc}
sudo make install
sudo ldconfig







