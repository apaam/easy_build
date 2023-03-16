message(STATUS "Configuring json ...")

if(JSON_INCLUDED)
  return()
endif()
set(JSON_INCLUDED TRUE)

if(USE_INTERNAL_JSON)
  if(NOT EXISTS "${CONTRIB_ROOT_DIR}/json/src/include/nlohmann/json.hpp")
    message(SEND_ERROR "Submodule json missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # json is a head only package, so only include dir is needed.
  add_custom_target(JSON)
  set(JSON_INCLUDE_DIRS ${CONTRIB_ROOT_DIR}/json/src/include)
else()
  find_package(JSON)
  if(NOT JSON_FOUND)
    message(SEND_ERROR "Can't find system json package.")
  endif()
endif()

message(STATUS "Using JSON as heads only package")
message(STATUS "Using JSON_INCLUDE_DIRS=${JSON_INCLUDE_DIRS}")
