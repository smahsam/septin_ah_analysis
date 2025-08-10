#!/bin/bash
# Comments for running on the GPU cluster
#SBATCH --job-name=gromacs
#SBATCH --nodes=10
#SBATCH --cpus-per-task=4
#SBATCH --constraint=rome,ib
#SBATCH -p ccb
module purge
module load modules/2.1
module load openmpi/4.0.7
#module load plumed/mpi-2.8.1
#module load gromacs/mpi-plumed-2022.3
module load gromacs/mpi-2022

minit=step5_input
rest_prefix=step5_input
mini_prefix=step6.0_minimization
equi_prefix=step6.%d_equilibration
prod_prefix=step7_production
prod_step=step7
mpirun --map-by socket:pe=$OMP_NUM_THREADS -np 300 gmx_mpi mdrun -deffnm metad_2d_short

# See if we can run the precursor steps
mpirun -np 1 gmx_mpi grompp -f ${mini_prefix}.mdp -o ${mini_prefix}.tpr -c ${minit}.gro -r ${rest_prefix}.gro -p topol.top -n index.ndx
mpirun gmx_mpi mdrun -v -deffnm ${mini_prefix}

# Equilibration only!
let cnt=1
let cntmax=6
while [ $cnt -le $cntmax ] ; do
 pcnt=$((cnt-1))
 istep=`printf ${equi_prefix} ${cnt}`
 pstep=`printf ${equi_prefix} ${pcnt}`
 if [ $cnt -eq 1 ]
 then
  pstep=${mini_prefix}
 fi
 mpirun -np 1 gmx_mpi grompp -f ${istep}.mdp -o ${istep}.tpr -c ${pstep}.gro -r ${rest_prefix}.gro -p topol.top -n index.ndx -maxwarn 2
 mpirun gmx_mpi mdrun -v -deffnm ${istep}
 ((cnt++))
done
