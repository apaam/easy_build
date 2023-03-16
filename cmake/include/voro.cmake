message(STATUS "Configuring voro ...")

if(VORO_INCLUDED)
  return()
endif()
set(VORO_INCLUDED TRUE)

if(USE_INTERNAL_VORO)
  set(VORO_EP_DIR ${CONTRIB_ROOT_DIR}/voro/ep)
  set(VORO_SOURCE_DIR ${CONTRIB_ROOT_DIR}/voro/src)
  set(VORO_BUILD_DIR ${CONTRIB_ROOT_DIR}/voro/build)
  set(VORO_INSTALL_DIR ${CONTRIB_ROOT_DIR}/voro/install)

  if(NOT EXISTS "${VORO_SOURCE_DIR}/Makefile")
    message(SEND_ERROR "Submodule voro missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  set(TMP_C_FLAGS "-Wall -ansi -pedantic -O3 -fPIC")

  # use voro as heads only package for now
  ExternalProject_Add(
    VORO
    PREFIX ${VORO_EP_DIR}
    SOURCE_DIR ${VORO_SOURCE_DIR}
    BINARY_DIR ${VORO_BUILD_DIR}
    INSTALL_DIR ${VORO_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    DOWNLOAD_COMMAND cp -a ${VORO_SOURCE_DIR}/. ${VORO_BUILD_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make -j${NUM_CORES} CXX=${CMAKE_CXX_COMPILER}
                  CFLAGS=${TMP_C_FLAGS} PREFIX=${VORO_INSTALL_DIR}
    INSTALL_COMMAND make -j${NUM_CORES} install CXX=${CMAKE_CXX_COMPILER}
                    CFLAGS=${TMP_C_FLAGS} PREFIX=${VORO_INSTALL_DIR})

  set(VORO_INCLUDE_DIRS ${VORO_INSTALL_DIR}/include)
  set(VORO_LIBRARIES voro++)
  set(VORO_LIBRARY_DIRS ${VORO_INSTALL_DIR}/lib)
else()
  find_package(VORO)
  if(NOT VORO_FOUND)
    message(SEND_ERROR "Can't find system voro package.")
  endif()
endif()

message(STATUS "Using VORO_INCLUDE_DIRS=${VORO_INCLUDE_DIRS}")
message(STATUS "Using VORO_LIBRARIES=${VORO_LIBRARIES}")
message(STATUS "Using VORO_LIBRARY_DIRS=${VORO_LIBRARY_DIRS}")
