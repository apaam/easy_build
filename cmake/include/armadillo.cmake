message(STATUS "Configuring armadillo ...")

if(ARMADILLO_INCLUDED)
  return()
endif()
set(ARMADILLO_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/openblas.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/lapack.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/arpack.cmake)

if(USE_INTERNAL_ARMADILLO)
  set(ARMADILLO_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/armadillo/ep)
  set(ARMADILLO_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/armadillo/src)
  set(ARMADILLO_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/armadillo/build)
  set(ARMADILLO_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/armadillo/install)

  if(NOT EXISTS "${ARMADILLO_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule armadillo missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    ARMADILLO
    PREFIX ${ARMADILLO_EP_ROOT}
    SOURCE_DIR ${ARMADILLO_SOURCE_DIR}
    BINARY_DIR ${ARMADILLO_BUILD_DIR}
    INSTALL_DIR ${ARMADILLO_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_PREFIX=${ARMADILLO_INSTALL_DIR} -DBUILD_SHARED_LIBS=OFF
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DALLOW_OPENBLAS_MACOS=TRUE
      ${ARMADILLO_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_LAPACK)
    add_dependencies(ARMADILLO LAPACK)
  endif(USE_INTERNAL_LAPACK)
  if(USE_INTERNAL_OPENBLAS)
    add_dependencies(ARMADILLO OPENBLAS)
  endif(USE_INTERNAL_OPENBLAS)
  if(USE_INTERNAL_ARPACK)
    add_dependencies(ARMADILLO ARPACK)
  endif(USE_INTERNAL_ARPACK)

  set(ARMADILLO_INCLUDE_DIRS ${ARMADILLO_INSTALL_DIR}/include)
  set(ARMADILLO_LIBRARIES armadillo)
  set(ARMADILLO_LIBRARY_DIRS ${ARMADILLO_INSTALL_DIR}/lib)
else()
  find_package(ARMADILLO)
  if(NOT ARMADILLO_FOUND)
    message(SEND_ERROR "Can't find system armadillo package.")
  endif()
endif()

add_compile_definitions(ARMA_DONT_USE_WRAPPER ARMA_DONT_USE_HDF5)
set(ARMADILLO_LIBRARIES ${OPENBLAS_LIBRARIES} ${LAPACK_LIBRARIES}
                        ${ARPACK_LIBRARIES})
include_directories(AFTER ${ARMADILLO_INCLUDE_DIRS})
link_directories(AFTER ${ARMADILLO_LIBRARY_DIRS})
message(STATUS "Using ARMADILLO_INCLUDE_DIRS=${ARMADILLO_INCLUDE_DIRS}")
message(STATUS "Using ARMADILLO_LIBRARIES=${ARMADILLO_LIBRARIES}")
message(STATUS "Using ARMADILLO_LIBRARY_DIRS=${ARMADILLO_LIBRARY_DIRS}")
