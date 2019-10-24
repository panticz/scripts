$!/bin/bash

URL=https://software.intel.com/sites/default/files/managed/cc/19/l_mklb_p_2019.6.005.tgz

# Download and extract LINPACK
[ ! -d /tmp/l_mklb_p_* ] && wget -qO- ${URL} | tar -xz -C /tmp

# Run LINPACK
(
  cd /tmp/l_mklb_p_*/benchmarks_*/linux/mkl/benchmarks/linpack
  ./runme_xeon64
)
