#!/bin/bash

#SBATCH --job-name=BabelStream
#SBATCH --time=0:20:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=128

#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --account=z19

total_tasks=$(( $SLURM_JOB_NUM_NODES * 128 ))
timestamp=$(date '+%Y%m%d%H%M')
outfile="omp-stream_${SLURM_JOB_NUM_NODES}nodes_${total_tasks}procs_${timestamp}.res"

echo ""
echo "Running on ${SLURM_JOB_NUM_NODES} nodes, ${SLURM_TASKS_PER_NODE} processes per node, $SLURM_CPUS_PER_TASK threads per process" > $outfile

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores

export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Launch the parallel job
echo "srun --hint=nomultithread --distribution=block:block _build_cce_omp/omp-stream" >> $outfile
srun --hint=nomultithread --distribution=block:block _build_cce_omp/omp-stream  >> $outfile

