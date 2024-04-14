#! /usr/bin/bash

#SBATCH --job-name=mpi_hello 
#SBATCH --chdir=/home/dpattisapu/task1_2
#SBATCH --output=mpi_hello.stdout
#SBATCH --error=mpi_hello.stderr
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --time=3:00:00

module load openmpi
mpicc -o /home/dpattisapu/task1_2/hello /home/dpattisapu/task1_2/mpi_hello.c
mpiexec -n 2 /home/dpattisapu/task1_2/hello
