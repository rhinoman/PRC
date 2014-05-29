#!/bin/bash -e
# Builds and tests PRC
source ./scripts/ci/common.sh
mkdir -p build
cd build

cmake -G "Unix Makefiles" ..

make -j ${NUMTHREADS}

ctest -V --output-on-failure . 

