message(STATUS "Configuring flex ...")

if(FLEX_INCLUDED)
  return()
endif()
set(FLEX_INCLUDED TRUE)

if(USE_INTERNAL_FLEX)
  set(FLEX_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/flex/ep)
  set(FLEX_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/flex/src)
  set(FLEX_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/flex/build)
  set(FLEX_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/flex/install)

  if(NOT EXISTS "${FLEX_SOURCE_DIR}/autogen.sh")
    message(SEND_ERROR "Submodule flex missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  # to be revised
  ExternalProject_Add(
    FLEX
    PREFIX ${FLEX_EP_ROOT}
    SOURCE_DIR ${FLEX_SOURCE_DIR}
    BINARY_DIR ${FLEX_BUILD_DIR}
    INSTALL_DIR ${FLEX_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

  set(FLEX_INCLUDE_DIRS ${FLEX_INSTALL_DIR}/include)
  set(FLEX_LIBRARIES flex)
  set(FLEX_LIBRARY_DIRS ${FLEX_INSTALL_DIR}/lib)
else()
  find_package(FLEX)
  if(NOT FLEX_FOUND)
    message(SEND_ERROR "Can't find system flex package.")
  endif()
endif()

set(FLEX_LIBRARIES ${FLEX_LIBRARIES})
include_directories(AFTER ${FLEX_INCLUDE_DIRS})
link_directories(AFTER ${FLEX_LIBRARY_DIRS})
message(STATUS "Using FLEX_INCLUDE_DIRS=${FLEX_INCLUDE_DIRS}")
message(STATUS "Using FLEX_LIBRARIES=${FLEX_LIBRARIES}")
message(STATUS "Using FLEX_LIBRARY_DIRS=${FLEX_LIBRARY_DIRS}")
