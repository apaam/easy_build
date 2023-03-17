cmake_minimum_required(VERSION 3.12)

project(EASY_BUILD)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/find)
include(ExternalProject)

# pre-settings
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

# dealii
option(USE_INTERNAL_DEALII "use internal dealii" ON)
option(BUILD_DEALII "build dealii" OFF)
if(BUILD_DEALII)
  include(cmake/include/dealii.cmake)

  if(USE_INTERNAL_DEALII)
    add_dependencies(${PROJECT_NAME} DEALII)
  endif()
endif()

# flex
option(USE_INTERNAL_FLEX "use internal flex" ON)
option(BUILD_FLEX "build flex" OFF)
if(BUILD_FLEX)
  include(cmake/include/flex.cmake)

  if(USE_INTERNAL_FLEX)
    add_dependencies(${PROJECT_NAME} FLEX)
  endif()
endif()

# hdf5
option(USE_INTERNAL_HDF5 "use internal hdf5" ON)
option(BUILD_HDF5 "build hdf5" OFF)
if(BUILD_HDF5)
  include(cmake/include/hdf5.cmake)

  if(USE_INTERNAL_HDF5)
    add_dependencies(${PROJECT_NAME} HDF5)
  endif()
endif()

# json
option(USE_INTERNAL_JSON "use internal json" ON)
option(BUILD_JSON "build json" OFF)
if(BUILD_JSON)
  include(cmake/include/json.cmake)

  if(USE_INTERNAL_JSON)
    add_dependencies(${PROJECT_NAME} JSON)
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

# openfoam
option(USE_INTERNAL_OPENFOAM "use internal openfoam" ON)
option(BUILD_OPENFOAM "build openfoam" OFF)
if(BUILD_OPENFOAM)
  include(cmake/include/openfoam.cmake)

  if(USE_INTERNAL_OPENFOAM)
    add_dependencies(${PROJECT_NAME} OPENFOAM)
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

# petsc
option(USE_INTERNAL_PETSC "use internal petsc" ON)
option(BUILD_PETSC "build petsc" OFF)
if(BUILD_PETSC)
  include(cmake/include/petsc.cmake)

  if(USE_INTERNAL_PETSC)
    add_dependencies(${PROJECT_NAME} PETSC)
  endif()
endif()

# scotch
option(USE_INTERNAL_SCOTCH "use internal scotch" ON)
option(BUILD_SCOTCH "build scotch" OFF)
if(BUILD_SCOTCH)
  include(cmake/include/scotch.cmake)

  if(USE_INTERNAL_SCOTCH)
    add_dependencies(${PROJECT_NAME} SCOTCH)
  endif()
endif()

# trilinos
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
