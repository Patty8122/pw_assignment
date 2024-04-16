#! /usr/bin/bash

git clone https://github.com/OpenFOAM/OpenFOAM-dev.git
git clone https://github.com/OpenFOAM/ThirdParty-dev.git
source /contrib/OpenFOAM-dev/etc/bashrc
cd OpenFOAM-dev
sudo yum install -y flex
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-7
scl enable devtoolset-7 bash
./Allwmake
# cd ThirdParty-dev
# ./makeParaView
# wmRefresh