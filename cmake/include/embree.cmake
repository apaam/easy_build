message(STATUS "Configuring embree ...")

if(EMBREE_INCLUDED)
  return()
endif()
set(EMBREE_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/tbb.cmake)
# include(${CMAKE_SOURCE_DIR}/cmake/include/glfw.cmake)

if(USE_INTERNAL_EMBREE)
  set(EMBREE_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/embree/ep)
  set(EMBREE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/embree/src)
  set(EMBREE_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/embree/build)
  set(EMBREE_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/embree/install)

  if(NOT EXISTS "${EMBREE_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule embree missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    EMBREE
    PREFIX ${EMBREE_EP_ROOT}
    SOURCE_DIR ${EMBREE_SOURCE_DIR}
    BINARY_DIR ${EMBREE_BUILD_DIR}
    INSTALL_DIR ${EMBREE_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
      -DCMAKE_INSTALL_PREFIX=${EMBREE_INSTALL_DIR} -DEMBREE_TUTORIALS=OFF
      -DEMBREE_ISPC_SUPPORT=OFF -DEMBREE_STATIC_LIB=ON -DEMBREE_MAX_ISA=SSE2
      -DEMBREE_TBB_ROOT=${TBB_INCLUDE_DIRS}/../ ${EMBREE_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_TBB)
    add_dependencies(EMBREE TBB)
  endif(USE_INTERNAL_TBB)

  set(EMBREE_INCLUDE_DIRS ${EMBREE_INSTALL_DIR}/include)
  set(EMBREE_LIBRARIES embree3 sys math simd lexers tasking)
  set(EMBREE_LIBRARY_DIRS ${EMBREE_INSTALL_DIR}/lib)
else()
  find_package(EMBREE)
  if(NOT EMBREE_FOUND)
    message(SEND_ERROR "Can't find system embree package.")
  endif()
endif()

set(EMBREE_LIBRARIES ${EMBREE_LIBRARIES} ${TBB_LIBRARIES})
include_directories(AFTER ${EMBREE_INCLUDE_DIRS})
link_directories(AFTER ${EMBREE_LIBRARY_DIRS})
message(STATUS "Using EMBREE_INCLUDE_DIRS=${EMBREE_INCLUDE_DIRS}")
message(STATUS "Using EMBREE_LIBRARIES=${EMBREE_LIBRARIES}")
message(STATUS "Using EMBREE_LIBRARY_DIRS=${EMBREE_LIBRARY_DIRS}")
