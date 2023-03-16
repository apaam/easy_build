message(STATUS "Configuring cereal ...")

if(CEREAL_INCLUDED)
  return()
endif()
set(CEREAL_INCLUDED TRUE)

if(USE_INTERNAL_CEREAL)
  if(NOT EXISTS
     "${CONTRIB_ROOT_DIR}/cereal/src/include/cereal/cereal.hpp")
    message(SEND_ERROR "Submodule cereal missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # cereal is a head only package, so only include dir is needed.
  add_custom_target(CEREAL)
  set(CEREAL_INCLUDE_DIRS ${CONTRIB_ROOT_DIR}/cereal/src/include)
else()
  find_package(CEREAL)
  if(NOT CEREAL_FOUND)
    message(SEND_ERROR "Can't find system cereal package.")
  endif()
endif()

message(STATUS "Using CEREAL as head only package")
message(STATUS "Using CEREAL_INCLUDE_DIRS=${CEREAL_INCLUDE_DIRS}")
