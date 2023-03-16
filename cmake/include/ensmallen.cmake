message(STATUS "Configuring ensmallen ...")

if(ENSMALLEN_INCLUDED)
  return()
endif()
set(ENSMALLEN_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/armadillo.cmake)

if(USE_INTERNAL_ENSMALLEN)
  set(ENSMALLEN_EP_DIR ${CONTRIB_ROOT_DIR}/ensmallen/ep)
  set(ENSMALLEN_SOURCE_DIR ${CONTRIB_ROOT_DIR}/ensmallen/src)
  set(ENSMALLEN_BUILD_DIR ${CONTRIB_ROOT_DIR}/ensmallen/build)
  set(ENSMALLEN_INSTALL_DIR ${CONTRIB_ROOT_DIR}/ensmallen/install)

  if(NOT EXISTS "${ENSMALLEN_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule ensmallen missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # use ensmallen as heads only package for now
  add_custom_target(ENSMALLEN)
  set(ENSMALLEN_INCLUDE_DIRS ${ENSMALLEN_SOURCE_DIR}/include)

  if(USE_INTERNAL_ARMADILLO)
    add_dependencies(ENSMALLEN ARMADILLO)
  endif()
else()
  find_package(ENSMALLEN)
  if(NOT ENSMALLEN_FOUND)
    message(SEND_ERROR "Can't find system ensmallen package.")
  endif()
endif()

set(ENSMALLEN_INCLUDE_DIRS ${ENSMALLEN_INCLUDE_DIRS} ${ARMADILLO_INCLUDE_DIRS})
set(ENSMALLEN_LIBRARIES ${ARMADILLO_LIBRARIES})
set(ENSMALLEN_LIBRARY_DIRS ${ARMADILLO_LIBRARY_DIRS})

message(STATUS "Using ENSMALLEN_INCLUDE_DIRS=${ENSMALLEN_INCLUDE_DIRS}")
message(STATUS "Using ENSMALLEN_LIBRARIES=${ENSMALLEN_LIBRARIES}")
message(STATUS "Using ENSMALLEN_LIBRARY_DIRS=${ENSMALLEN_LIBRARY_DIRS}")
