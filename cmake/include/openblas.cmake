message(STATUS "Configuring openblas ...")

if(OPENBLAS_INCLUDED)
  return()
endif()
set(OPENBLAS_INCLUDED TRUE)

if(USE_INTERNAL_OPENBLAS)
  set(OPENBLAS_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/openblas/ep)
  set(OPENBLAS_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/openblas/src)
  set(OPENBLAS_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/openblas/build)
  set(OPENBLAS_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/openblas/install)

  if(NOT EXISTS "${OPENBLAS_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule openblas missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    OPENBLAS
    PREFIX ${OPENBLAS_EP_ROOT}
    SOURCE_DIR ${OPENBLAS_SOURCE_DIR}
    BINARY_DIR ${OPENBLAS_BUILD_DIR}
    INSTALL_DIR ${OPENBLAS_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_PREFIX=${OPENBLAS_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_FLAGS=-pthread
      -DCMAKE_C_FLAGS=-pthread ${OPENBLAS_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(OPENBLAS_INCLUDE_DIRS ${OPENBLAS_INSTALL_DIR}/include)
  set(OPENBLAS_LIBRARIES libopenblas.a)
  set(OPENBLAS_LIBRARY_DIRS ${OPENBLAS_INSTALL_DIR}/lib)
else()
  find_package(OPENBLAS)
  if(NOT OPENBLAS_FOUND)
    message(SEND_ERROR "Can't find system openblas package.")
  endif()
endif()

include_directories(AFTER ${OPENBLAS_INCLUDE_DIRS})
link_directories(AFTER ${OPENBLAS_LIBRARY_DIRS})
message(STATUS "Using OPENBLAS_INCLUDE_DIRS=${OPENBLAS_INCLUDE_DIRS}")
message(STATUS "Using OPENBLAS_LIBRARIES=${OPENBLAS_LIBRARIES}")
message(STATUS "Using OPENBLAS_LIBRARY_DIRS=${OPENBLAS_LIBRARY_DIRS}")
