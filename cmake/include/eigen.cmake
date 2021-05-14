message(STATUS "Configuring eigen ...")

if(EIGEN_INCLUDED)
  return()
endif()
set(EIGEN_INCLUDED TRUE)

if(USE_INTERNAL_EIGEN)
  if(NOT EXISTS "${CMAKE_SOURCE_DIR}/contrib/eigen/src/Eigen/Eigen")
    message(SEND_ERROR "Submodule eigen missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  # json is a head only package, so only include dir is needed.
  set(EIGEN_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/contrib/eigen/src)
else()
  find_package(EIGEN3)
  if(NOT EIGEN3_FOUND)
    message(SEND_ERROR "Can't find system eigen package.")
  endif()
endif()

include_directories(AFTER ${EIGEN_INCLUDE_DIRS})
message(STATUS "Using EIGEN_INCLUDE_DIRS=${EIGEN_INCLUDE_DIRS}")
