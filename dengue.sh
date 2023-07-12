#!/bin/bash
#SBATCH --job-name Dengue
#SBATCH --mail-user smokhtar@unm.edu
#SBATCH --mail-type ALL
#SBATCH --output den.out
#SBATCH --error den.err
#SBATCH --time 24:00:00
##SBATCH --mem 50G
#SBATCH --ntasks 12
#SBATCH --partition general
#SBATCH --cpus-per-task 4

echo Node list: $SLURM_JOB_NODELIST
echo Numeber of Task: $SLURM_NTASKS


module load miniconda3
source activate test1
##Rscript R0_Calculation_0.5Degree01.R
##Rscript R0_Calculation_0.5Degree02.R
##Rscript R0_Calculation_0.5Degree03.R
##Rscript R0_mergeR0.R
Rscript R0_statistics.R

