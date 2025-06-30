#!/bin/bash

#SBATCH --job-name=babelstream
#SBATCH --time=0:5:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:4
#SBATCH --partition=gpu-a100-80
#SBATCH --qos=dev

# Load the correct modules

module avail

lscpu

nvidia-smi

export OMP_NUM_THREADS=1

./cuda-stream
