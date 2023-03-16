message(STATUS "Configuring cgal ...")

if(CGAL_INCLUDED)
  return()
endif()
set(CGAL_INCLUDED TRUE)

# dependencies
include(${CMAKE_SOURCE_DIR}/cmake/include/boost.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/gmp.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/mpfr.cmake)

if(USE_INTERNAL_CGAL)
  set(CGAL_EP_DIR ${CONTRIB_ROOT_DIR}/cgal/ep)
  set(CGAL_SOURCE_DIR ${CONTRIB_ROOT_DIR}/cgal/src)
  set(CGAL_BUILD_DIR ${CONTRIB_ROOT_DIR}/cgal/build)
  set(CGAL_INSTALL_DIR ${CONTRIB_ROOT_DIR}/cgal/install)

  if(NOT EXISTS "${CGAL_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule cgal missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  ExternalProject_Add(
    CGAL
    PREFIX ${CGAL_EP_DIR}
    SOURCE_DIR ${CGAL_SOURCE_DIR}
    BINARY_DIR ${CGAL_BUILD_DIR}
    INSTALL_DIR ${CGAL_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${CGAL_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${CGAL_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_BOOST)
    add_dependencies(CGAL BOOST)
  endif()

  if(USE_INTERNAL_GMP)
    add_dependencies(CGAL GMP)
  endif()

  if(USE_INTERNAL_MPFR)
    add_dependencies(CGAL MPFR)
  endif()

  set(CGAL_INCLUDE_DIRS ${CGAL_INSTALL_DIR}/include)
else()
  find_package(CGAL)
  if(NOT CGAL_FOUND)
    message(SEND_ERROR "Can't find system cgal package.")
  endif()
endif()

# need to revise
set(CGAL_INCLUDE_DIRS ${CGAL_INCLUDE_DIRS} ${BOOST_INCLUDE_DIRS}
                      ${GMP_INCLUDE_DIRS} ${MPFR_INCLUDE_DIRS})
set(CGAL_LIBRARIES ${BOOST_LIBRARIES} ${GMP_LIBRARIES} ${MPFR_LIBRARIES})
set(CGAL_LIBRARY_DIRS ${BOOST_LIBRARY_DIRS} ${GMP_LIBRARY_DIRS}
                      ${MPFR_LIBRARY_DIRS})

message(STATUS "Using CGAL_INCLUDE_DIRS=${CGAL_INCLUDE_DIRS}")
message(STATUS "Using CGAL_LIBRARIES=${CGAL_LIBRARIES}")
message(STATUS "Using CGAL_LIBRARY_DIRS=${CGAL_LIBRARY_DIRS}")
