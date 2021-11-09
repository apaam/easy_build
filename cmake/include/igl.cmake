message(STATUS "Configuring igl ...")

if(IGL_INCLUDED)
  return()
endif()
set(IGL_INCLUDED TRUE)

# include(${CMAKE_SOURCE_DIR}/cmake/include/embree.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/eigen.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/cgal.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/openmp.cmake)

if(USE_INTERNAL_IGL)
  set(IGL_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/igl/ep)
  set(IGL_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/igl/src)
  set(IGL_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/igl/build)
  set(IGL_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/igl/install)

  if(NOT EXISTS "${IGL_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule igl missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # use igl as heads only package for now
  ExternalProject_Add(
    IGL
    PREFIX ${IGL_EP_ROOT}
    SOURCE_DIR ${IGL_SOURCE_DIR}
    BINARY_DIR ${IGL_BUILD_DIR}
    INSTALL_DIR ${IGL_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

  if(USE_INTERNAL_CGAL)
    add_dependencies(IGL CGAL)
  endif()

  if(USE_INTERNAL_OPENMP)
    add_dependencies(IGL OPENMP)
  endif()

  # if(USE_INTERNAL_EMBREE)
  #   add_dependencies(IGL EMBREE)
  # endif()

  set(IGL_INCLUDE_DIRS ${IGL_SOURCE_DIR}/include)
  set(IGL_EXTERNAL_DIRS ${IGL_SOURCE_DIR}/external)
else()
  find_package(IGL)
  if(NOT IGL_FOUND)
    message(SEND_ERROR "Can't find system igl package.")
  endif()
endif()

set(IGL_LIBRARIES ${EMBREE_LIBRARIES} ${CGAL_LIBRARIES} ${OPENMP_LIBRARIES})
include_directories(AFTER ${IGL_INCLUDE_DIRS} ${IGL_EXTERNAL_DIRS})
message(STATUS "Using IGL_INCLUDE_DIRS=${IGL_INCLUDE_DIRS}")
message(STATUS "Using IGL_LIBRARIES=${IGL_LIBRARIES}")
message(STATUS "Using IGL_LIBRARY_DIRS=${IGL_LIBRARY_DIRS}")
