message(STATUS "Configuring mpfr ...")

if(MPFR_INCLUDED)
  return()
endif()
set(MPFR_INCLUDED TRUE)

if(USE_INTERNAL_MPFR)
  set(MPFR_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/mpfr/ep)
  set(MPFR_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/mpfr/src)
  set(MPFR_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/mpfr/build)
  set(MPFR_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/mpfr/install)

  if(NOT EXISTS "${MPFR_SOURCE_DIR}/configure")
    message(SEND_ERROR "Submodule mpfr missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    MPFR
    PREFIX ${MPFR_EP_ROOT}
    SOURCE_DIR ${MPFR_SOURCE_DIR}
    BINARY_DIR ${MPFR_BUILD_DIR}
    INSTALL_DIR ${MPFR_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ../src/configure --prefix=${MPFR_INSTALL_DIR}
    BUILD_COMMAND make -j${NUM_CORES}
    INSTALL_COMMAND make -j${NUM_CORES} install)

  set(MPFR_INCLUDE_DIRS ${MPFR_INSTALL_DIR}/include)
  set(MPFR_LIBRARIES mpfr)
  set(MPFR_LIBRARY_DIRS ${MPFR_INSTALL_DIR}/lib)
else()
  find_package(MPFR)
  if(NOT MPFR_FOUND)
    message(SEND_ERROR "Can't find system mpfr package.")
  endif()
endif()

set(MPFR_LIBRARIES ${MPFR_LIBRARIES})
include_directories(AFTER ${MPFR_INCLUDE_DIRS})
link_directories(AFTER ${MPFR_LIBRARY_DIRS})
message(STATUS "Using MPFR_INCLUDE_DIRS=${MPFR_INCLUDE_DIRS}")
message(STATUS "Using MPFR_LIBRARIES=${MPFR_LIBRARIES}")
message(STATUS "Using MPFR_LIBRARY_DIRS=${MPFR_LIBRARY_DIRS}")
