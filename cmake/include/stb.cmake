message(STATUS "Configuring stb ...")

if(STB_INCLUDED)
  return()
endif()
set(STB_INCLUDED TRUE)

if(USE_INTERNAL_STB)
  if(NOT EXISTS "${CMAKE_SOURCE_DIR}/contrib/stb/src/stb_image.h")
    message(SEND_ERROR "Submodule stb missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # stb is a head only package, so only include dir is needed.
  set(STB_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/contrib/stb/src)
else()
  find_package(STB)
  if(NOT STB_FOUND)
    message(SEND_ERROR "Can't find system stb package.")
  endif()
endif()

include_directories(AFTER ${STB_INCLUDE_DIRS})
message(STATUS "Using STB_INCLUDE_DIRS=${STB_INCLUDE_DIRS}")
