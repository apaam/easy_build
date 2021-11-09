message(STATUS "Configuring openmp ...")

if(OPENMP_INCLUDED)
  return()
endif()
set(OPENMP_INCLUDED TRUE)

if(USE_INTERNAL_OPENMP)
  set(OPENMP_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/openmp/ep)
  set(OPENMP_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/openmp/src)
  set(OPENMP_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/openmp/build)
  set(OPENMP_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/openmp/install)

  if(NOT EXISTS "${OPENMP_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule armadillo missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    OPENMP
    PREFIX ${OPENMP_EP_ROOT}
    SOURCE_DIR ${OPENMP_SOURCE_DIR}
    BINARY_DIR ${OPENMP_BUILD_DIR}
    INSTALL_DIR ${OPENMP_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${OPENMP_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_FLAGS=-pthread
      -DCMAKE_C_FLAGS=-pthread -DLIBOMP_ENABLE_SHARED=OFF ${OPENMP_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(OPENMP_INCLUDE_DIRS ${OPENMP_INSTALL_DIR}/include)
  set(OPENMP_LIBRARIES omp)
  set(OPENMP_LIBRARY_DIRS ${OPENMP_INSTALL_DIR}/lib)
else()
  find_package(OPENMP)
  if(NOT OPENMP_FOUND)
    message(SEND_ERROR "Can't find system openmp package.")
  endif()
endif()

set(OPENMP_LIBRARIES ${OPENMP_LIBRARIES} gfortran)
include_directories(AFTER ${OPENMP_INCLUDE_DIRS})
link_directories(AFTER ${OPENMP_LIBRARY_DIRS})
message(STATUS "Using OPENMP_INCLUDE_DIRS=${OPENMP_INCLUDE_DIRS}")
message(STATUS "Using OPENMP_LIBRARIES=${OPENMP_LIBRARIES}")
message(STATUS "Using OPENMP_LIBRARY_DIRS=${OPENMP_LIBRARY_DIRS}")
