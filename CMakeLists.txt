cmake_minimum_required(VERSION 3.12)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/find)

# pre-settings
project(EASY_BUILD CXX C)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX
      ${CMAKE_SOURCE_DIR}/install
      CACHE PATH "Install path prefix" FORCE)
endif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
add_compile_options(
  -std=c++17
  -march=native
  -Ofast
  -pipe
  -fPIC
  -ltcmalloc
  -fopenmp
  -fuse-ld=lld)

if(UNIX AND NOT APPLE)
  set(DEFAULT_LIBS "${DEFAULT_LIBS}  -lc -lm -lrt -lpthread -ldl")
  message(STATUS "Default libraries: ${DEFAULT_LIBS}")

  set(CMAKE_CXX_STANDARD_LIBRARIES ${DEFAULT_LIBS})
  set(CMAKE_C_STANDARD_LIBRARIES ${DEFAULT_LIBS})
endif()

# create a dumpy project target
add_custom_target(${PROJECT_NAME})

# contrib root dir
set(CONTRIB_ROOT_DIR
    ${CMAKE_SOURCE_DIR}/contrib
    CACHE PATH "contrib path prefix")
message(STATUS "using CONTRIB_ROOT_DIR=${CONTRIB_ROOT_DIR}")

# for peridigm
option(USE_INTERNAL_PERIDIGM "use internal peridigm" ON)
option(USE_INTERNAL_TRILINOS "use internal trilinos" ON)
option(USE_INTERNAL_HDF5 "use internal hdf5" ON)
option(USE_INTERNAL_NETCDF "use internal netcdf" ON)
option(USE_INTERNAL_YAML "use internal yaml" ON)

# for liggghts
option(USE_INTERNAL_LIGGGHTS "use internal liggghts" ON)
option(USE_INTERNAL_VTK "use internal vtk" ON)

# for netdem
option(USE_INTERNAL_NETDEM "use internal netdem" ON)
option(USE_INTERNAL_ARMADILLO "use internal armadillo" ON)
option(USE_INTERNAL_ARPACK "use internal arpack" ON)
option(USE_INTERNAL_CEREAL "use internal cereal" ON)
option(USE_INTERNAL_CGAL "use internal cgal" ON)
option(USE_INTERNAL_CORK "use internal cork" ON)
option(USE_INTERNAL_EIGEN "use internal eigen" ON)
option(USE_INTERNAL_ENSMALLEN "use internal ensmallen" ON)
option(USE_INTERNAL_GTEST "use internal gtest" ON)
option(USE_INTERNAL_IGL "use internal igl" ON)
option(USE_INTERNAL_JSON "use internal json" ON)
option(USE_INTERNAL_LAPACK "use internal lapack" ON)
option(USE_INTERNAL_MLPACK "use internal mlpack" ON)
option(USE_INTERNAL_MPFR "use internal mpfr" ON)
option(USE_INTERNAL_OPENBLAS "use internal openblas" ON)
option(USE_INTERNAL_OPENMP "use internal openmp" ON)

# the compilation of these is really time consuming, chose to use pre-build
# packages in the os.
option(USE_INTERNAL_BOOST "use internal boost" OFF)
option(USE_INTERNAL_MPI "use internal mpi" OFF)
option(USE_INTERNAL_GMP "use internal gmp, usually shipped with gcc" OFF)

# configuration
include(ExternalProject)
include(cmake/include/mpi.cmake)

option(ENABLE_PERIDIGM "build peridigm" OFF)
if(ENABLE_PERIDIGM)
  include(cmake/include/peridigm.cmake)

  if(USE_INTERNAL_PERIDIGM)
    add_dependencies(${PROJECT_NAME} PERIDIGM)
  endif()
endif()

option(ENABLE_LIGGGHTS "build liggghts" OFF)
if(ENABLE_LIGGGHTS)
  include(cmake/include/liggghts.cmake)

  if(USE_INTERNAL_LIGGGHTS)
    add_dependencies(${PROJECT_NAME} LIGGGHTS)
  endif()
endif()

option(ENABLE_NETDEM "build netdem" OFF)
if(ENABLE_NETDEM)
  include(cmake/include/netdem.cmake)

  if(USE_INTERNAL_NETDEM)
    add_dependencies(${PROJECT_NAME} NETDEM)
  endif()
endif()

# tests
option(ENABLE_TESTS "build tests" ON)
if(ENABLE_TESTS)
  add_subdirectory(tests)
endif()

# tools
option(ENABLE_TOOLS "build tools" ON)
if(ENABLE_TOOLS)
  add_subdirectory(tools)
endif()

# examples
option(ENABLE_EXAMPLES "build examples" ON)
if(ENABLE_EXAMPLES)
  add_subdirectory(examples)
endif()
