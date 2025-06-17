# BabelStream benchmark

**Note:** This benchmark/repository is closely based on the one used for the [NERSC-10 benchmarks](https://www.nersc.gov/systems/nersc-10/benchmarks/)

The Babelstream benchmark was developed at the University of Bristol to measure the achievable main memory bandwidth across variety of CPUs and GPUs using simple kernels. These kernels process data that is larger than the largest level of cache so that transfers from main memory are always in play. Dynamically allocated arrays are used to prevent any compile time optimizations. Babelstream provides implementations in multiple programming models for CPUs and GPUs. When used for GPUs, this benchmark does not include the data transfer time for CPU-GPU transfers.

## Status

Stable

## Maintainers

- @aturner-epcc ([https://github.com/aturner-epcc](https://github.com/aturner-epcc))

## Overview

### Software

- [https://github.com/UoB-HPC/BabelStream](https://github.com/UoB-HPC/BabelStream)

### Architectures

- CPU: x86, Arm
- GPU: NVIDIA, AMD, Intel

### Languages and programming models

- Programming languages: C++
- Parallel models: OpenMP
- Accelerator offload models: CUDA, HIP, OpenACC, Kokkos, SYCL, RAJA, OpenCL, TBB

## Building the benchmark

At the moment, only manual build instructions are available. We plan to add Spack
build instructions in the future.

### Manual build

The Babelstream source code can be obtained from:
https://github.com/UoB-HPC/BabelStream.git using:

```bash
git clone https://github.com/UoB-HPC/BabelStream.git .
```

The series of commands to configure and build BabelStream is
```bash
mkdir build
cd build
cmake -DMODEL=<model> <CMAKE_OPTIONS> ../
make
```
where `<model>` should be substituted with one of
the programming models implemented in the current version of BabelStream<br>
( omp; ocl; std; std20; hip; cuda; kokkos;
  sycl; sycl2020; acc; raja; tbb; thrust )
  

Additional CMake variables may be needed for some programming models.
For example,
<table><tr><th> OpenMP </th><th> OpenMP-offload </th><th> CUDA </th><tr>
<tr><td>

```bash
cmake \
-DMODEL=omp \
../ 
```

</td><td>

```bash
cmake \
-DMODEL=omp \
-DCMAKE_CXX_COMPILER=nvc++ \
-DOFFLOAD=ON \
-DOFFLOAD_FLAGS="-mp=gpu -gpu=cc80 -Minfo" \
../ 
```

</td><td>

```bash
cmake \
-DMODEL=cuda \
-DCMAKE_CXX_COMPILER=nvc++ \
-DCMAKE_CUDA_COMPILER=nvcc \
-DCUDA_ARCH=sm_80 \
../ 
```

</td></tr></table>

## Running the benchmark

At the moment, only manual run instructions are available. We plan to add ReFrame
build instructions in the future.

### Running manually

The BabelStream executable, `<model>-stream`, can be found in the `build` directory
and can be run without additional arguments, for example:

```bash
#OpenMP execution on a CPU
> export OMP_NUM_THREADS=4
> ./omp-stream 

#OpenMP-Offload exection on a GPU
> ./omp-stream 
```

All the kernels are validated at the end of their execution;
no explicit validation test is needed.

## Example performance data

The primary figure of merit (FoM) is the Triad rate (MB/s).
Report all data printed to stdout.

```bash
# Tursa
> ./cuda-stream
BabelStream
Version: 5.0
Implementation: CUDA
Running kernels 100 times
Precision: double
Array size: 268.4 MB (=0.3 GB)
Total size: 805.3 MB (=0.8 GB)
Using CUDA device NVIDIA A100-SXM4-80GB
Driver: 12030
Memory: DEFAULT
Reduction kernel config: 432 groups of (fixed) size 1024
Init: 0.078539 s (=10253.531921 MBytes/sec)
Read: 0.000810 s (=994263.084401 MBytes/sec)
Function    MBytes/sec  Min (sec)   Max         Average     
Copy        1709360.800 0.00031     0.00032     0.00032     
Mul         1676181.608 0.00032     0.00033     0.00033     
Add         1715845.543 0.00047     0.00048     0.00047     
Triad       1724827.354 0.00047     0.00047     0.00047     
Dot         1586905.948 0.00034     0.00036     0.00035   
```

```bash
# ARCHER2
> salloc --nodes=1 --tasks-per-node=1 --cpus-per-task=128 --time=0:20:0
> export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
> export OMP_PLACES=cores
> srun --hint=nomultithread --distribution=block:block _build_cce_omp/omp-stream
BabelStream
Version: 5.0
Implementation: OpenMP
Running kernels 1000 times
Precision: double
Array size: 268.4 MB (=0.3 GB)
Total size: 805.3 MB (=0.8 GB)
Init: 0.043660 s (=18444.837169 MBytes/sec)
Read: 0.053030 s (=15185.751175 MBytes/sec)
Function    MBytes/sec  Min (sec)   Max         Average     
Copy        421983.400  0.00127     0.00160     0.00132     
Mul         295653.136  0.00182     0.00227     0.00189     
Add         319003.459  0.00252     0.00278     0.00262     
Triad       293900.783  0.00274     0.00303     0.00282     
Dot         340542.635  0.00158     0.00224     0.00167     
```

## Allowed Modifications

Offerors are permitted to modify the benchmark in the following ways.

**Programming Pragmas**:<br>
- The Offeror may choose any of the programming models implemented in BabelStream.
- The Offeror may modify the programming (e.g. OpenMP, OpenACC) pragmas in the benchmark as required  to permit execution on the proposed system, provided: 
   - All modified sources and build scripts must be included in the RFP response.
   - Any modified code used for the response must continue to be a valid program (compliant to the standard being proposed in the Offeror's response).

**Memory Allocation**<br>
- For accelerators, arrays should only be allocated on device's global memory, any pre-staging of data or use of user controlled cache is not allowed.
- The sizes of the allocated arrays must be 4x larger than the largest level of cache. Array sizes can be modified by changing the variable `ARRAY_SIZE` on `line 55` of `./src/main.cpp` in BabelStream benchmark source code. 

**Concurrency & Affinity**<br>
- The Offeror may change the kernel launch configurations, type of memory management (e.g. CUDA managed memory, separate host and device pointers etc.).

## License

This benchmark description and associated files are released under the MIT license.
