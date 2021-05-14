message(STATUS "Configuring cork ...")

if(CORK_INCLUDED)
  return()
endif()
set(CORK_INCLUDED TRUE)

# dependencies
include(${CMAKE_SOURCE_DIR}/cmake/include/gmp.cmake)

if(USE_INTERNAL_CORK)
  set(CORK_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/cork/ep)
  set(CORK_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/cork/src)
  set(CORK_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/cork/build)
  set(CORK_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/cork/install)

  if(NOT EXISTS "${CORK_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule cork missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    CORK
    PREFIX ${CORK_EP_ROOT}
    SOURCE_DIR ${CORK_SOURCE_DIR}
    BINARY_DIR ${CORK_BUILD_DIR}
    INSTALL_DIR ${CORK_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${CORK_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${CORK_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND "")

  set(CORK_INCLUDE_DIRS
      ${CORK_SOURCE_DIR}/src
      ${CORK_SOURCE_DIR}/src/accel
      ${CORK_SOURCE_DIR}/src/file_formats
      ${CORK_SOURCE_DIR}/src/isct
      ${CORK_SOURCE_DIR}/src/math
      ${CORK_SOURCE_DIR}/src/mesh
      ${CORK_SOURCE_DIR}/src/rawmesh
      ${CORK_SOURCE_DIR}/src/util)
  set(CORK_LIBRARIES cork)
  set(CORK_LIBRARY_DIRS ${CORK_BUILD_DIR})
else()
  find_package(CORK)
  if(NOT CORK_FOUND)
    message(SEND_ERROR "Can't find system cork package.")
  endif()
endif()

set(CORK_LIBRARIES ${CORK_LIBRARIES} ${GMP_LIBRARIES})
include_directories(BEFORE ${CORK_INCLUDE_DIRS})
link_directories(AFTER ${CORK_LIBRARY_DIRS})
message(STATUS "Using CORK_INCLUDE_DIRS=${CORK_INCLUDE_DIRS}")
message(STATUS "Using CORK_LIBRARIES=${CORK_LIBRARIES}")
message(STATUS "Using CORK_LIBRARY_DIRS=${CORK_LIBRARY_DIRS}")
