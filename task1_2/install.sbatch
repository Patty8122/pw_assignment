#!/bin/bash

#SBATCH --job-name=installmpi
#SBATCH --chdir=/contrib
#SBATCH --output=installmpi.stdout
#SBATCH --error=installmpi.stderr
#SBATCH --nodes=8
#SBATCH --ntasks=8
#SBATCH --time=3:00:00

# install
# wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.gz
# tar -xvf openmpi-1.10.2.tar.gz
# echo "Unzipped. Starting install..."
cd openmpi-1.10.2
./configure --with-slurm --with-pmi --prefix="/home/$USER/.openmpi"  
make
make install
echo "Install complete."
export PATH="$PATH:/home/$USER/.openmpi/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.openmpi/lib/"  
echo export PATH="$PATH:/home/$USER/.openmpi/bin" >> /home/$USER/.bashrc
echo export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.openmpi/lib/">>/home/$USER/.bashrc  
