### Benchmark Description
Babelstream measures the achievable main memory bandwidth across variety of CPUs and GPUs using simple kernels. These kernels process data that is larger than the smallest level of cache so that transfers from main memory are always in play. This benchmark uses dynamically allocated arrays to prevent any compile time optimizations. Babelstream benchmark provides implementations in multiple programming models for CPUs and GPUs.

When used for GPUs, this benchmark does not include the data transfer time for CPU-GPU transfers.

### Allowed Modifications
Offerors are permitted to modify the benchmark in the following ways:

#### Programming Pragmas
the Offeror may modify the programming (e.g. OpenMP, OpenACC) pragmas in the benchmark as required 
to permit execution on the proposed system provided: 
- All modified sources and build scripts must be included in the RFP response.
- Any modified code used for the response must continue to be a valid program (compliant to the standard being proposed in the Offeror's response).

#### Memory Allocation

- For accelerators, arrays should only be allocated on device's global memory, any pre-staging of data or use of user controlled cache is not allowed.
- The sizes of the allocated arrays must be 4x larger than the lowest level of cache. 

### Run Rules
The Offeror may change the kernel launch configurations, type of memory management (e.g. CUDA managed memory, separate host and device pointers etc.).

### How to build, run and verify.
Babelstream benchmark can be obtained from: https://github.com/UoB-HPC/BabelStream.git using:

```bash
git clone https://github.com/UoB-HPC/BabelStream.git .
```
To build the benchmark for `xx` programming model follow:

```bash
mkdir build
cd build
cmake -DMODEL=xx ../
make
```

Please note that you may need to provide additional CMake variables depending upon the type of programming model being used for example
when using `cuda` programming model for a device with compute capability 8.0 below options are used:
```bash
cmake -DMODEL=cuda -DCMAKE_CXX_COMPILER=nvc++ -DCMAKE_CUDA_COMPILER=nvcc -DCUDA_ARCH=sm_80 ../
```

All the kernels are validated at the end of their execution, no explicit validation test is needed. Below are some examples of building and running this benchmark for different architectures.

#### Using OpenMP on a CPU
```bash
mkdir build
cd build
cmake -DMODEL=omp ../
make

> export OMP_NUM_THREADS=4
> ./omp-stream 
BabelStream
Version: 4.0
Implementation: OpenMP
Running kernels 100 times
Precision: double
Array size: 268.4 MB (=0.3 GB)
Total size: 805.3 MB (=0.8 GB)
Function    MBytes/sec  Min (sec)   Max         Average     
Copy        17543.651   0.03060     0.12682     0.03857     
Mul         16751.736   0.03205     0.17480     0.04149     
Add         18410.511   0.04374     0.13842     0.05503     
Triad       30536.210   0.02637     0.10638     0.05581     
Dot         20623.267   0.02603     0.25623     0.03863     

```
### Reporting
The primary FOM is the Triad rate (MB/s). Please report all data printed to stdout.