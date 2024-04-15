#! /usr/bin/bash

wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.gz
tar -xvf openmpi-1.10.2.tar.gz
echo "Unzipped. Starting install..."
cd openmpi-1.10.2
./configure --with-slurm --with-pmi --prefix="/contrib/.openmpi"  
make
make install
echo "Install complete."
