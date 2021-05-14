message(STATUS "Configuring hwloc ...")

if(HWLOC_INCLUDED)
  return()
endif()
set(HWLOC_INCLUDED TRUE)

if(USE_INTERNAL_HWLOC)
  set(HWLOC_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/hwloc/ep)
  set(HWLOC_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/hwloc/src)
  set(HWLOC_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/hwloc/build)
  set(HWLOC_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/hwloc/install)

  if(NOT EXISTS "${HWLOC_SOURCE_DIR}/autogen.sh")
    message(SEND_ERROR "Submodule hwloc missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  # cannot use gcc as compiler, do not know why
  ExternalProject_Add(
    HWLOC
    PREFIX ${HWLOC_EP_ROOT}
    SOURCE_DIR ${HWLOC_SOURCE_DIR}
    BINARY_DIR ${HWLOC_BUILD_DIR}
    INSTALL_DIR ${HWLOC_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      ${HWLOC_SOURCE_DIR}/autogen.sh && ${HWLOC_SOURCE_DIR}/configure
      --prefix=${HWLOC_INSTALL_DIR} --enable-static=yes --enable-shared=no}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(HWLOC_INCLUDE_DIRS ${HWLOC_INSTALL_DIR}/include)
  set(HWLOC_LIBRARIES hwloc netloc)
  set(HWLOC_LIBRARY_DIRS ${HWLOC_INSTALL_DIR}/lib)
else()
  find_package(HWLOC)
  if(NOT HWLOC_FOUND)
    message(SEND_ERROR "Can't find system hwloc package.")
  endif()
endif()

set(HWLOC_LIBRARIES ${HWLOC_LIBRARIES})
include_directories(AFTER ${HWLOC_INCLUDE_DIRS})
link_directories(AFTER ${HWLOC_LIBRARY_DIRS})
message(STATUS "Using HWLOC_INCLUDE_DIRS=${HWLOC_INCLUDE_DIRS}")
message(STATUS "Using HWLOC_LIBRARIES=${HWLOC_LIBRARIES}")
message(STATUS "Using HWLOC_LIBRARY_DIRS=${HWLOC_LIBRARY_DIRS}")
