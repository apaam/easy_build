message(STATUS "Configuring lapack ...")

if(LAPACK_INCLUDED)
  return()
endif()
set(LAPACK_INCLUDED TRUE)

if(USE_INTERNAL_LAPACK)
  set(LAPACK_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/lapack/ep)
  set(LAPACK_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/lapack/src)
  set(LAPACK_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/lapack/build)
  set(LAPACK_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/lapack/install)

  if(NOT EXISTS "${LAPACK_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule lapack missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    LAPACK
    PREFIX ${LAPACK_EP_ROOT}
    SOURCE_DIR ${LAPACK_SOURCE_DIR}
    BINARY_DIR ${LAPACK_BUILD_DIR}
    INSTALL_DIR ${LAPACK_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_LIBDIR=${LAPACK_INSTALL_DIR}/lib
      -DCMAKE_INSTALL_INCLUDEDIR=${LAPACK_INSTALL_DIR}/include
      -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_FLAGS=-pthread
      -DCMAKE_C_FLAGS=-pthread ${LAPACK_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(LAPACK_INCLUDE_DIRS ${LAPACK_INSTALL_DIR}/include)
  set(LAPACK_LIBRARIES liblapack.a)
  set(LAPACK_LIBRARY_DIRS ${LAPACK_INSTALL_DIR}/lib ${GFORTRAN_LIBRARY_DIR})
else()
  find_package(LAPACK)
  if(NOT LAPACK_FOUND)
    message(SEND_ERROR "Can't find system lapack package.")
  endif()
endif()

set(LAPACK_LIBRARIES ${LAPACK_LIBRARIES} gfortran)
include_directories(AFTER ${LAPACK_INCLUDE_DIRS})
link_directories(AFTER ${LAPACK_LIBRARY_DIRS} ${GFORTRAN_LIBRARY_DIR})
message(STATUS "Using LAPACK_INCLUDE_DIRS=${LAPACK_INCLUDE_DIRS}")
message(STATUS "Using LAPACK_LIBRARIES=${LAPACK_LIBRARIES}")
message(STATUS "Using LAPACK_LIBRARY_DIRS=${LAPACK_LIBRARY_DIRS}")
