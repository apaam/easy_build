message(STATUS "Configuring cereal ...")

if(CEREAL_INCLUDED)
  return()
endif()
set(CEREAL_INCLUDED TRUE)

if(USE_INTERNAL_CEREAL)
  if(NOT EXISTS
     "${CMAKE_SOURCE_DIR}/contrib/cereal/src/include/cereal/cereal.hpp")
    message(SEND_ERROR "Submodule cereal missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # cereal is a head only package, so only include dir is needed.
  set(CEREAL_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/contrib/cereal/src/include)
else()
  find_package(CEREAL)
  if(NOT CEREAL_FOUND)
    message(SEND_ERROR "Can't find system cereal package.")
  endif()
endif()

include_directories(AFTER ${CEREAL_INCLUDE_DIRS})
message(STATUS "Using CEREAL_INCLUDE_DIRS=${CEREAL_INCLUDE_DIRS}")
