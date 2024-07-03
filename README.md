# Benchmark Description

**Note:** This benchmark/repository is closely based on the one used for the [NERSC-10 benchmarks](https://www.nersc.gov/systems/nersc-10/benchmarks/)

The Babelstream benchmark was developed at the University of Bristol to measure the achievable main memory bandwidth across variety of CPUs and GPUs using simple kernels. These kernels process data that is larger than the largest level of cache so that transfers from main memory are always in play. Dynamically allocated arrays are used to prevent any compile time optimizations. Babelstream provides implementations in multiple programming models for CPUs and GPUs. When used for GPUs, this benchmark does not include the data transfer time for CPU-GPU transfers.

# Allowed Modifications
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

# Installation

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

# Execution

The BabelStream executable, `<model>-stream`,
can be found in the `build` directory
and can be run without additional arguments,
for example:

```bash
#OpenMP execution on a CPU
> export OMP_NUM_THREADS=4
> ./omp-stream 

#OpenMP-Offload exection on a GPU
> ./omp-stream 
```

All the kernels are validated at the end of their execution;
no explicit validation test is needed.


# Sample Output

```bash
#OpenMP-offload on Perlmutter
> ./omp-stream
BabelStream
Version: 4.0
Implementation: OpenMP
Running kernels 100 times
Precision: double
Array size: 268.4 MB (=0.3 GB)
Total size: 805.3 MB (=0.8 GB)
Function    MBytes/sec  Min (sec)   Max         Average     
Copy        1338402.984 0.00040     0.00041     0.00040     
Mul         1298571.257 0.00041     0.00042     0.00042     
Add         1368223.698 0.00059     0.00059     0.00059     
Triad       1376683.861 0.00058     0.00059     0.00059     
Dot         436311.922  0.00123     0.00124     0.00124 
```

# Reporting
The primary figure of merit (FOM) is the Triad rate (MB/s).
Report all data printed to stdout.

# References

- Deakin T, Price J, Martineau M, McIntosh-Smith S.
"Evaluating attainable memory bandwidth of 
  parallel programming models via BabelStream."
International Journal of Computational Science and Engineering.
Special issue. Vol. 17, No. 3, pp. 247–262. 2018.
DOI: 10.1504/IJCSE.2018.095847
- NERSC-10 benchmarks. Accessed 2 July 2024, https://www.nersc.gov/systems/nersc-10/benchmarks/
