message(STATUS "Configuring stb ...")

if(STB_INCLUDED)
  return()
endif()
set(STB_INCLUDED TRUE)

if(USE_INTERNAL_STB)
  if(NOT EXISTS "${CONTRIB_ROOT_DIR}/stb/src/stb_image.h")
    message(SEND_ERROR "Submodule stb missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  # stb is a head only package, so only include dir is needed.
  add_custom_target(STB)
  set(STB_INCLUDE_DIRS ${CONTRIB_ROOT_DIR}/stb/src)
else()
  find_package(STB)
  if(NOT STB_FOUND)
    message(SEND_ERROR "Can't find system stb package.")
  endif()
endif()

message(STATUS "Using STB as head only package")
message(STATUS "Using STB_INCLUDE_DIRS=${STB_INCLUDE_DIRS}")
