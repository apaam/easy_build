message(STATUS "Configuring ensmallen ...")

if(ENSMALLEN_INCLUDED)
  return()
endif()
set(ENSMALLEN_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/armadillo.cmake)

if(USE_INTERNAL_ENSMALLEN)
  set(ENSMALLEN_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/ensmallen/ep)
  set(ENSMALLEN_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/ensmallen/src)
  set(ENSMALLEN_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/ensmallen/build)
  set(ENSMALLEN_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/ensmallen/install)

  if(NOT EXISTS "${ENSMALLEN_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule ensmallen missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # use ensmallen as heads only package for now
  set(ENSMALLEN_INCLUDE_DIRS ${ENSMALLEN_SOURCE_DIR}/include)
else()
  find_package(ENSMALLEN)
  if(NOT ENSMALLEN_FOUND)
    message(SEND_ERROR "Can't find system ensmallen package.")
  endif()
endif()

include_directories(AFTER ${ENSMALLEN_INCLUDE_DIRS})
message(STATUS "Using ENSMALLEN_INCLUDE_DIRS=${ENSMALLEN_INCLUDE_DIRS}")
