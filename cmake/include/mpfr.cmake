message(STATUS "Configuring mpfr ...")

if(MPFR_INCLUDED)
  return()
endif()
set(MPFR_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/gmp.cmake)

if(USE_INTERNAL_MPFR)
  set(MPFR_EP_DIR ${CONTRIB_ROOT_DIR}/mpfr/ep)
  set(MPFR_SOURCE_DIR ${CONTRIB_ROOT_DIR}/mpfr/src)
  set(MPFR_BUILD_DIR ${CONTRIB_ROOT_DIR}/mpfr/build)
  set(MPFR_INSTALL_DIR ${CONTRIB_ROOT_DIR}/mpfr/install)

  if(NOT EXISTS "${MPFR_SOURCE_DIR}/configure.ac")
    message(SEND_ERROR "Submodule mpfr missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  ExternalProject_Add(
    MPFR
    PREFIX ${MPFR_EP_DIR}
    SOURCE_DIR ${MPFR_SOURCE_DIR}
    BINARY_DIR ${MPFR_BUILD_DIR}
    INSTALL_DIR ${MPFR_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    DOWNLOAD_COMMAND cp -a ${MPFR_SOURCE_DIR}/. ${MPFR_BUILD_DIR}
    PATCH_COMMAND autoreconf --install ${MPFR_BUILD_DIR}
    CONFIGURE_COMMAND ./configure --with-gmp=${GMP_INCLUDE_DIRS}/../
                      --prefix=${MPFR_INSTALL_DIR}
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

set(MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIRS} ${GMP_INCLUDE_DIRS})
set(MPFR_LIBRARIES ${MPFR_LIBRARIES} ${GMP_LIBRARIES})
set(MPFR_LIBRARY_DIRS ${MPFR_LIBRARY_DIRS} ${GMP_LIBRARY_DIRS})

message(STATUS "Using MPFR_INCLUDE_DIRS=${MPFR_INCLUDE_DIRS}")
message(STATUS "Using MPFR_LIBRARIES=${MPFR_LIBRARIES}")
message(STATUS "Using MPFR_LIBRARY_DIRS=${MPFR_LIBRARY_DIRS}")
