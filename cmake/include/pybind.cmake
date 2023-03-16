message(STATUS "Configuring pybind ...")

if(PYBIND_INCLUDED)
  return()
endif()
set(PYBIND_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/python.cmake)

if(USE_INTERNAL_PYBIND)
  set(PYBIND_EP_DIR ${CONTRIB_ROOT_DIR}/pybind/ep)
  set(PYBIND_SOURCE_DIR ${CONTRIB_ROOT_DIR}/pybind/src)
  set(PYBIND_BUILD_DIR ${CONTRIB_ROOT_DIR}/pybind/build)
  set(PYBIND_INSTALL_DIR ${CONTRIB_ROOT_DIR}/pybind/install)

  if(NOT EXISTS "${PYBIND_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule pybind missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # use pybind as heads only package for now
  ExternalProject_Add(
    PYBIND
    PREFIX ${PYBIND_EP_DIR}
    SOURCE_DIR ${PYBIND_SOURCE_DIR}
    BINARY_DIR ${PYBIND_BUILD_DIR}
    INSTALL_DIR ${PYBIND_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

  set(PYBIND_INCLUDE_DIRS ${PYBIND_SOURCE_DIR}/include)
else()
  find_package(PYBIND)
  if(NOT PYBIND_FOUND)
    message(SEND_ERROR "Can't find system pybind package.")
  endif()
endif()

set(PYBIND_INCLUDE_DIRS ${PYBIND_INCLUDE_DIRS} ${PYTHON_INCLUDE_DIRS})
set(PYBIND_LIBRARIES ${PYBIND_LIBRARIES} ${PYTHON_LIBRARIES})
set(PYBIND_LIBRARY_DIRS ${PYBIND_LIBRARY_DIRS} ${PYTHON_LIBRARY_DIRS})

message(STATUS "Using PYBIND_INCLUDE_DIRS=${PYBIND_INCLUDE_DIRS}")
message(STATUS "Using PYBIND_LIBRARIES=${PYBIND_LIBRARIES}")
message(STATUS "Using PYBIND_LIBRARY_DIRS=${PYBIND_LIBRARY_DIRS}")