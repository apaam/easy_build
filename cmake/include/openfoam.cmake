message(STATUS "Configuring openfoam ...")

if(OPENFOAM_INCLUDED)
  return()
endif()
set(OPENFOAM_INCLUDED TRUE)

if(USE_INTERNAL_OPENFOAM)
  set(OPENFOAM_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/openfoam/ep)
  set(OPENFOAM_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/openfoam/OpenFOAM-dev)
  set(OPENFOAM_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/openfoam/OpenFOAM-dev)
  set(OPENFOAM_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/openfoam/install)

  if(NOT EXISTS "${OPENFOAM_SOURCE_DIR}/Allwmake")
    message(SEND_ERROR "Submodule openfoam missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  configure_file(${CMAKE_SOURCE_DIR}/cmake/config/openfoam_install.sh
                 ${OPENFOAM_SOURCE_DIR}/openfoam_install.sh @ONLY)

  # to be revised
  ExternalProject_Add(
    OPENFOAM
    PREFIX ${OPENFOAM_EP_ROOT}
    SOURCE_DIR ${OPENFOAM_SOURCE_DIR}
    BINARY_DIR ${OPENFOAM_BUILD_DIR}
    INSTALL_DIR ${OPENFOAM_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND bash ${OPENFOAM_SOURCE_DIR}/openfoam_install.sh
    INSTALL_COMMAND "")

  set(OPENFOAM_INCLUDE_DIRS ${OPENFOAM_INSTALL_DIR}/include)
  set(OPENFOAM_LIBRARIES openfoam)
  set(OPENFOAM_LIBRARY_DIRS ${OPENFOAM_INSTALL_DIR}/lib)
else()
  find_package(OPENFOAM)
  if(NOT OPENFOAM_FOUND)
    message(SEND_ERROR "Can't find system openfoam package.")
  endif()
endif()

set(OPENFOAM_LIBRARIES ${OPENFOAM_LIBRARIES})
include_directories(AFTER ${OPENFOAM_INCLUDE_DIRS})
link_directories(AFTER ${OPENFOAM_LIBRARY_DIRS})
message(STATUS "Using OPENFOAM_INCLUDE_DIRS=${OPENFOAM_INCLUDE_DIRS}")
message(STATUS "Using OPENFOAM_LIBRARIES=${OPENFOAM_LIBRARIES}")
message(STATUS "Using OPENFOAM_LIBRARY_DIRS=${OPENFOAM_LIBRARY_DIRS}")
