message(STATUS "Configuring eigen ...")

if(EIGEN_INCLUDED)
  return()
endif()
set(EIGEN_INCLUDED TRUE)

if(USE_INTERNAL_EIGEN)
  if(NOT EXISTS "${CONTRIB_ROOT_DIR}/eigen/src/Eigen/Eigen")
    message(SEND_ERROR "Submodule eigen missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # json is a head only package, so only include dir is needed.
  add_custom_target(EIGEN)
  set(EIGEN_INCLUDE_DIRS ${CONTRIB_ROOT_DIR}/eigen/src)
else()
  find_package(EIGEN3)
  if(NOT EIGEN3_FOUND)
    message(SEND_ERROR "Can't find system eigen package.")
  endif()
endif()

message(STATUS "Using EIGEN as head only package")
message(STATUS "Using EIGEN_INCLUDE_DIRS=${EIGEN_INCLUDE_DIRS}")
