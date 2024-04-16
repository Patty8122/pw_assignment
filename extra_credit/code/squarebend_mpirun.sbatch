#! /usr/bin/bash

#SBATCH --nodes=2
#SBATCH --tasks-per-node=4
#SBATCH --job-name=squarebend_mpirun
#SBATCH --chdir=/contrib/OpenFOAM-dev/tutorialsTest/fluid/squareBend
#SBATCH -t 00:30:00
#SBATCH --output=log-squarebend.out
#SBATCH --error=log-squarebend.err

export PATH="$PATH:/contrib/.openmpi/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/contrib/.openmpi/lib/"
source /contrib/OpenFOAM-dev/etc/bashrc
mpiexec -n 8 -hostfile /contrib/OpenFOAM-dev/tutorialsTest/fluid/squareBend/machine.txt -x FOAM_SETTINGS /contrib/OpenFOAM-dev/bin/foamExec -prefix /contrib foamRun -parallel > /contrib/OpenFOAM-dev/tutorialsTest/fluid/squareBend/log 2>&1
# foamJob -p foamRun  
# mpirun -np 8 -x FOAM_SETTINGS /contrib/OpenFOAM-dev/bin/foamExec -prefix /contrib foamRun -parallel > log 2>&1
echo "Results are in the file titled 'log' in the current directory."FOAM_SETTINGS
