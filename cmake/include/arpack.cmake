message(STATUS "Configuring arpack ...")

if(ARPACK_INCLUDED)
  return()
endif()
set(ARPACK_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/lapack.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/openblas.cmake)

if(USE_INTERNAL_ARPACK)
  set(ARPACK_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/arpack/ep)
  set(ARPACK_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/arpack/src)
  set(ARPACK_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/arpack/build)
  set(ARPACK_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/arpack/install)

  if(NOT EXISTS "${ARPACK_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule arpack missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    ARPACK
    PREFIX ${ARPACK_EP_ROOT}
    SOURCE_DIR ${ARPACK_SOURCE_DIR}
    BINARY_DIR ${ARPACK_BUILD_DIR}
    INSTALL_DIR ${ARPACK_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${ARPACK_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_FLAGS=-pthread
      -DCMAKE_C_FLAGS=-pthread -DCMAKE_Fortran_FLAGS=-pthread
      -DLAPACK_LIBRARIES=${LAPACK_LIBRARY_DIRS}/${LAPACK_LIBRARIES}
      -DBLAS_LIBRARIES=${OPENBLAS_LIBRARY_DIRS}/${OPENBLAS_LIBRARIES}
      -DEXAMPLES=OFF -DMPI=OFF -DBUILD_SHARED_LIBS=OFF ${ARPACK_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_LAPACK)
    add_dependencies(ARPACK LAPACK)
  endif(USE_INTERNAL_LAPACK)
  if(USE_INTERNAL_OPENBLAS)
    add_dependencies(ARPACK OPENBLAS)
  endif(USE_INTERNAL_OPENBLAS)

  set(ARPACK_INCLUDE_DIRS ${ARPACK_INSTALL_DIR}/include)
  set(ARPACK_LIBRARIES arpack)
  set(ARPACK_LIBRARY_DIRS ${ARPACK_INSTALL_DIR}/lib)
else()
  find_package(ARPACK)
  if(NOT ARPACK_FOUND)
    message(SEND_ERROR "Can't find system arpack package.")
  endif()
endif()

set(ARPACK_LIBRARIES ${ARPACK_LIBRARIES} gfortran)
include_directories(AFTER ${ARPACK_INCLUDE_DIRS})
link_directories(AFTER ${ARPACK_LIBRARY_DIRS})
message(STATUS "Using ARPACK_INCLUDE_DIRS=${ARPACK_INCLUDE_DIRS}")
message(STATUS "Using ARPACK_LIBRARIES=${ARPACK_LIBRARIES}")
message(STATUS "Using ARPACK_LIBRARY_DIRS=${ARPACK_LIBRARY_DIRS}")
