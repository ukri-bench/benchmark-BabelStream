### Benchmark Description
Babelstream measures the achievable main memory bandwidth across variety of CPUs and GPUs using simple kernels. These kernels process data that is larger than the smallest level of cache so that transfers from main memory are always in play. This benchmark uses dynamically allocated arrays to prevent any compile time optimizations. Babelstream benchmark provides implementations in multiple programming models for CPUs and GPUs.

When used for GPUs, this benchmark does not include the data transfer time for CPU-GPU transfers.

### Allowed Modifications
Offerors are permitted to modify the benchmark in the following ways:

####Programming Pragmas
the Offeror may modify the programming (e.g. OpenMP, OpenACC) pragmas in the benchmark as required 
to permit execution on the proposed system provided: 
- All modified sources and build scripts must be included in the RFP response.
- Any modified code used for the response must continue to be a valid program (compliant to the standard being proposed in the Offeror's response).
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

All the kernels are validated at the end of their execution, no explicit validation test is needed.


### Reporting
The primary FOM is the Triad rate (MB/s). Report all data printed to stdout.