message(STATUS "Configuring json ...")

if(JSON_INCLUDED)
  return()
endif()
set(JSON_INCLUDED TRUE)

if(USE_INTERNAL_JSON)
  if(NOT EXISTS
     "${CMAKE_SOURCE_DIR}/contrib/json/src/include/nlohmann/json.hpp")
    message(SEND_ERROR "Submodule json missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # json is a head only package, so only include dir is needed.
  set(JSON_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/contrib/json/src/include)
else()
  find_package(JSON)
  if(NOT JSON_FOUND)
    message(SEND_ERROR "Can't find system json package.")
  endif()
endif()

include_directories(AFTER ${JSON_INCLUDE_DIRS})
message(STATUS "Using JSON_INCLUDE_DIRS=${JSON_INCLUDE_DIRS}")
