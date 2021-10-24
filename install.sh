#!/bin/bash

mkdir -p build && cd build

TYPE=${TYPE:-Release}
NUM_CORES=12

TESTS=${TESTS:-ON}
TOOLS=${TOOLS:-ON}
EXAMPLES=${EXAMPLES:-ON}

# package options
HDF5=${HDF5:-OFF}
LAPACK=${LAPACK:-OFF}
LIGGGHTS=${LIGGGHTS:-OFF}
NETCDF=${NETCDF:-OFF}
NETDEM=${NETDEM:-OFF}
OPENBLAS=${OPENBLAS:-OFF}
PERIDIGM=${PERIDIGM:-OFF}
TRILINOS=${TRILINOS:-OFF}
VTK=${VTK:-OFF}
YAML=${YAML:-OFF}

if hash ninja; then
  USE_NINJA=1
  CMAKE_GENERATOR_FLAG=-GNinja
  GENERATOR=$(which ninja)
else
  GENERATOR=$(which make)
fi

MPICC_COMPILER=$(which mpicc)
MPICXX_COMPILER=$(which mpicxx)

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CMAKE_C_COMPILER=$(which gcc-10)
  CMAKE_CXX_COMPILER=$(which g++-10)
  CMAKE_Fortran_COMPILER=$(which gfortran-10)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  CMAKE_C_COMPILER=$(which gcc-11)
  CMAKE_CXX_COMPILER=$(which g++-11)
  CMAKE_Fortran_COMPILER=$(which gfortran-11)
else
  CMAKE_C_COMPILER=$(which gcc)
  CMAKE_CXX_COMPILER=$(which g++)
  CMAKE_Fortran_COMPILER=$(which gfortran)
fi

cmake ${CMAKE_GENERATOR_FLAG} \
  -DCMAKE_BUILD_TYPE=${TYPE} -DNUM_CORES=${NUM_CORES} \
  -DENABLE_TESTS=${TESTS} -DENABLE_TOOLS=${TOOLS} -DENABLE_EXAMPLES=${EXAMPLES} \
  -DBUILD_HDF5=${HDF5} \
  -DBUILD_LAPACK=${LAPACK} \
  -DBUILD_LIGGGHTS=${LIGGGHTS} \
  -DBUILD_NETCDF=${NETCDF} \
  -DBUILD_NETDEM=${NETDEM} \
  -DBUILD_OPENBLAS=${OPENBLAS} \
  -DBUILD_PERIDIGM=${PERIDIGM} \
  -DBUILD_TRILINOS=${TRILINOS} \
  -DBUILD_VTK=${VTK} \
  -DBUILD_YAML=${YAML} \
  -DCMAKE_GENERATOR_FLAG=${CMAKE_GENERATOR_FLAG} -DGENERATOR=${GENERATOR} \
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
  -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} \
  -DMPICXX_COMPILER=${MPICXX_COMPILER} -DMPICC_COMPILER=${MPICC_COMPILER} \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

if [ $USE_NINJA ]; then
  echo "Build with ninja"
  $GENERATOR -j$NUM_CORES
  # $GENERATOR -j$NUM_CORES install
else
  echo "Build with modern make"
  $GENERATOR -j$NUM_CORES
  # $GENERATOR -j$NUM_CORES install
fi
