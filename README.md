### Benchmark Description
Babelstream measures the data transfer rates to and from a GPU's global memory using the same basic kernels as in STREAM benchmark for CPUs.
This benchmark does not include the PCIe transfer time when measuring kernel execution times.

Babelstream benchmark provides implementations in multiple programming models for GPUs. This benchmark uses dynamically allocated arrays to prevent
any compile time optimizations. 

### What is Permitted and what is not
Offerors are permitted to modify the benchmark in the following ways:

Programming Pragmas - the Offeror may modify the programming (e.g. OpenMP, OpenACC) pragmas in the benchmark as required 
to permit execution on the proposed system provided: (1) all modified sources and build 
scripts must be included in the RFP response; (2) any modified code used for the response 
must continue to be a valid program (compliant to the standard being proposed in 
the Offeror's response).

Memory Allocation - Arrays should only be allocated on device's global memory, any pre-staging of data or 
use of user controlled cache is not allowed.

Array/Allocation Sizes - the sizes of the allocated arrays must be 4x larger than the lowest level of cache. 

### Run Rules
The Offeror may change the kernel launch configurations, type of memory management (e.g. CUDA managed memory, separate host and device pointers etc.).

### How to build, run and verify.
Babelstream benchmark can be obtained from: https://github.com/UoB-HPC/BabelStream.git

To build the benchmark for `xx` programming model:
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