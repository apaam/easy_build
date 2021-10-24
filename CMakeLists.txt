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

# for netdem
option(USE_INTERNAL_ARMADILLO "use internal armadillo" ON)
option(USE_INTERNAL_ARPACK "use internal arpack" ON)
option(USE_INTERNAL_CEREAL "use internal cereal" ON)
option(USE_INTERNAL_CGAL "use internal cgal" ON)
option(USE_INTERNAL_CORK "use internal cork" ON)
option(USE_INTERNAL_EIGEN "use internal eigen" ON)
option(USE_INTERNAL_ENSMALLEN "use internal ensmallen" ON)
option(USE_INTERNAL_GTEST "use internal gtest" ON)
option(USE_INTERNAL_HDF5 "use internal hdf5" ON)
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

# hdf5
option(USE_INTERNAL_HDF5 "use internal hdf5" ON)
option(BUILD_HDF5 "build hdf5" OFF)
if(BUILD_HDF5)
  include(cmake/include/hdf5.cmake)

  if(USE_INTERNAL_HDF5)
    add_dependencies(${PROJECT_NAME} HDF5)
  endif()
endif()

# lapack
option(USE_INTERNAL_LAPACK "use internal lapack" ON)
option(BUILD_LAPACK "build lapack" OFF)
if(BUILD_LAPACK)
  include(cmake/include/lapack.cmake)

  if(USE_INTERNAL_LAPACK)
    add_dependencies(${PROJECT_NAME} LAPACK)
  endif()
endif()

# liggghts
option(USE_INTERNAL_LIGGGHTS "use internal liggghts" ON)
option(BUILD_LIGGGHTS "build liggghts" OFF)
if(BUILD_LIGGGHTS)
  include(cmake/include/liggghts.cmake)

  if(USE_INTERNAL_LIGGGHTS)
    add_dependencies(${PROJECT_NAME} LIGGGHTS)
  endif()
endif()

# netcdf
option(USE_INTERNAL_NETCDF "use internal netcdf" ON)
option(BUILD_NETCDF "build netcdf" OFF)
if(BUILD_NETCDF)
  include(cmake/include/netcdf.cmake)

  if(USE_INTERNAL_NETCDF)
    add_dependencies(${PROJECT_NAME} NETCDF)
  endif()
endif()

# netdem
option(USE_INTERNAL_NETDEM "use internal netdem" ON)
option(BUILD_NETDEM "build netdem" OFF)
if(BUILD_NETDEM)
  include(cmake/include/netdem.cmake)

  if(USE_INTERNAL_NETDEM)
    add_dependencies(${PROJECT_NAME} NETDEM)
  endif()
endif()

# openblas
option(USE_INTERNAL_OPENBLAS "use internal openblas" ON)
option(BUILD_OPENBLAS "build openblas" OFF)
if(BUILD_OPENBLAS)
  include(cmake/include/openblas.cmake)

  if(USE_INTERNAL_OPENBLAS)
    add_dependencies(${PROJECT_NAME} OPENBLAS)
  endif()
endif()

# peridigm
option(USE_INTERNAL_PERIDIGM "use internal peridigm" ON)
option(BUILD_PERIDIGM "build peridigm" OFF)
if(BUILD_PERIDIGM)
  include(cmake/include/peridigm.cmake)

  if(USE_INTERNAL_PERIDIGM)
    add_dependencies(${PROJECT_NAME} PERIDIGM)
  endif()
endif()

# vtk
option(USE_INTERNAL_TRILINOS "use internal trilinos" ON)
option(BUILD_TRILINOS "build trilinos" OFF)
if(BUILD_TRILINOS)
  include(cmake/include/trilinos.cmake)

  if(USE_INTERNAL_TRILINOS)
    add_dependencies(${PROJECT_NAME} TRILINOS)
  endif()
endif()

# vtk
option(USE_INTERNAL_VTK "use internal vtk" ON)
option(BUILD_VTK "build vtk" OFF)
if(BUILD_VTK)
  include(cmake/include/vtk.cmake)

  if(USE_INTERNAL_VTK)
    add_dependencies(${PROJECT_NAME} VTK)
  endif()
endif()

# yaml
option(USE_INTERNAL_YAML "use internal yaml" ON)
option(BUILD_YAML "build yaml" OFF)
if(BUILD_YAML)
  include(cmake/include/yaml.cmake)

  if(USE_INTERNAL_YAML)
    add_dependencies(${PROJECT_NAME} YAML)
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
