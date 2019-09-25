$!/bin/bash

URL=https://software.intel.com/sites/default/files/managed/e4/1c/l_mklb_p_2019.5.004.tgz

# Download and extract LINPACK
[ ! -d /tmp/l_mklb_p_* ] && curl -s ${URL} | tar -xz -C /tmp

# Run LINPACK
(
  cd /tmp/l_mklb_p_*/benchmarks_*/linux/mkl/benchmarks/linpack
  ./runme_xeon64
)
