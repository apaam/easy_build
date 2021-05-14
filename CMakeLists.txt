cmake_minimum_required(VERSION 3.12)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/find)

# pre-settings
project(EASY_BUILD CXX C)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX
      ${CMAKE_SOURCE_DIR}/build
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

# packages
option(ENABLE_PERIDIGM "build peridigm" OFF)

# tests, tools and examples
option(ENABLE_TESTS "build tests" ON)
option(ENABLE_TOOLS "build tools" ON)
option(ENABLE_EXAMPLES "build examples" ON)

# for peridigm
option(USE_INTERNAL_PERIDIGM "use internal peridigm" ON)
option(USE_INTERNAL_TRILINOS "use internal trilinos" ON)
option(USE_INTERNAL_HDF5 "use internal hdf5" ON)
option(USE_INTERNAL_NETCDF "use internal netcdf" ON)
option(USE_INTERNAL_YAML "use internal yaml" ON)

# the compilation of these is really time consuming, chose to use pre-build
# packages in the os.
option(USE_INTERNAL_BOOST "use internal boost" OFF)
option(USE_INTERNAL_MPI "use internal mpi" OFF)
option(USE_INTERNAL_GMP "use internal gmp, usually shipped with gcc" OFF)

# configuration
include(ExternalProject)
include(cmake/include/mpi.cmake)

if(ENABLE_PERIDIGM)
  include(cmake/include/peridigm.cmake)
endif()

add_custom_target(${PROJECT_NAME})

if(ENABLE_PERIDIGM AND USE_INTERNAL_PERIDIGM)
  add_dependencies(${PROJECT_NAME} PERIDIGM)
endif()

# tests
if(ENABLE_TESTS)
  add_subdirectory(tests)
endif()

# tools
if(ENABLE_TOOLS)
  add_subdirectory(tools)
endif()

# examples
if(ENABLE_EXAMPLES)
  add_subdirectory(examples)
endif()
