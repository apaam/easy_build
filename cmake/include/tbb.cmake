message(STATUS "Configuring tbb ...")

if(TBB_INCLUDED)
  return()
endif()
set(TBB_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/hwloc.cmake)

if(USE_INTERNAL_TBB)
  set(TBB_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/tbb/ep)
  set(TBB_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/tbb/src)
  set(TBB_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/tbb/build)
  set(TBB_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/tbb/install)

  if(NOT EXISTS "${TBB_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule tbb missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # cannot use gcc as compiler, do not know why. Also, cannot build static lib.
  ExternalProject_Add(
    TBB
    PREFIX ${TBB_EP_ROOT}
    SOURCE_DIR ${TBB_SOURCE_DIR}
    BINARY_DIR ${TBB_BUILD_DIR}
    INSTALL_DIR ${TBB_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_LIBDIR=${TBB_INSTALL_DIR}/lib
      -DCMAKE_INSTALL_INCLUDEDIR=${TBB_INSTALL_DIR}/include
      -DCMAKE_HWLOC_2_LIBRARY_PATH=${HWLOC_LIBRARY_DIRS}
      -DCMAKE_HWLOC_2_INCLUDE_PATH=${HWLOC_INCLUDE_DIRS} ${TBB_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_HWLOC)
    add_dependencies(TBB HWLOC)
  endif(USE_INTERNAL_HWLOC)

  set(TBB_INCLUDE_DIRS ${TBB_INSTALL_DIR}/include)
  set(TBB_LIBRARIES tbb)
  set(TBB_LIBRARY_DIRS ${TBB_INSTALL_DIR}/lib)
else()
  find_package(TBB)
  if(NOT TBB_FOUND)
    message(SEND_ERROR "Can't find system tbb package.")
  endif()
endif()

set(TBB_LIBRARIES ${TBB_LIBRARIES} ${HWLOC_LIBRARIES})
include_directories(AFTER ${TBB_INCLUDE_DIRS})
link_directories(AFTER ${TBB_LIBRARY_DIRS})
message(STATUS "Using TBB_INCLUDE_DIRS=${TBB_INCLUDE_DIRS}")
message(STATUS "Using TBB_LIBRARIES=${TBB_LIBRARIES}")
message(STATUS "Using TBB_LIBRARY_DIRS=${TBB_LIBRARY_DIRS}")
