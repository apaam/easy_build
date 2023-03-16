message(STATUS "Configuring petsc ...")

if(PETSC_INCLUDED)
  return()
endif()
set(PETSC_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/lapack.cmake)

if(USE_INTERNAL_PETSC)
  set(PETSC_EP_ROOT ${CONTRIB_ROOT_DIR}/contrib/petsc/ep)
  set(PETSC_SOURCE_DIR ${CONTRIB_ROOT_DIR}/contrib/petsc/src)
  set(PETSC_BUILD_DIR ${CONTRIB_ROOT_DIR}/contrib/petsc/src)
  set(PETSC_INSTALL_DIR ${CONTRIB_ROOT_DIR}/contrib/petsc/install)

  if(NOT EXISTS "${PETSC_SOURCE_DIR}/configure")
    message(SEND_ERROR "Submodule petsc missing. To fix, try run: "
                       "git submodule update --init contrib/petsc/src")
  endif()

  ExternalProject_Add(
    PETSC
    PREFIX ${PETSC_EP_ROOT}
    SOURCE_DIR ${PETSC_SOURCE_DIR}
    BINARY_DIR ${PETSC_BUILD_DIR}
    INSTALL_DIR ${PETSC_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      ${PETSC_SOURCE_DIR}/configure --with-debugging=0 --with-mpi=0
      --with-cc=${CMAKE_C_COMPILER} --with-cxx=${CMAKE_CXX_COMPILER}
      --with-fc=${CMAKE_Fortran_COMPILER}
      --with-blaslapack-dir=${LAPACK_LIBRARY_DIRS} --prefix=${PETSC_INSTALL_DIR}
    BUILD_COMMAND make -j${NUM_CORES}
    INSTALL_COMMAND make -j${NUM_CORES} install)

  if(USE_INTERNAL_LAPACK)
    add_dependencies(PETSC LAPACK)
  endif(USE_INTERNAL_LAPACK)

  set(PETSC_INCLUDE_DIRS ${PETSC_INSTALL_DIR}/include)
  set(PETSC_LIBRARIES petsc)
  set(PETSC_LIBRARY_DIRS ${PETSC_INSTALL_DIR}/lib)
else()
  find_package(PETSC)
  if(NOT PETSC_FOUND)
    message(SEND_ERROR "Can't find system petsc package.")
  endif()
endif()

set(PETSC_LIBRARIES ${PETSC_LIBRARIES} ${TRILINOS_LIBRARIES} ${BOOST_LIBRARIES})
include_directories(AFTER ${PETSC_INCLUDE_DIRS})
link_directories(AFTER ${PETSC_LIBRARY_DIRS})
message(STATUS "Using PETSC_INCLUDE_DIRS=${PETSC_INCLUDE_DIRS}")
message(STATUS "Using PETSC_LIBRARIES=${PETSC_LIBRARIES}")
message(STATUS "Using PETSC_LIBRARY_DIRS=${PETSC_LIBRARY_DIRS}")
