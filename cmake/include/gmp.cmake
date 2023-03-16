message(STATUS "Configuring gmp ...")

if(GMP_INCLUDED)
  return()
endif()
set(GMP_INCLUDED TRUE)

if(USE_INTERNAL_GMP)
  message(
    SEND_ERROR "Setup steps for internal gmp not defined yet. "
               "Please check ${CMAKE_SOURCE_DIR}/cmake/include/gmp.cmake.")
else()
  find_package(GMP)
  if(NOT GMP_FOUND)
    message(SEND_ERROR "Can't find system gmp package.")
  endif()
endif()

message(STATUS "Using GMP_INCLUDE_DIRS=${GMP_INCLUDE_DIRS}")
message(STATUS "Using GMP_LIBRARIES=${GMP_LIBRARIES}")
message(STATUS "Using GMP_LIBRARY_DIRS=${GMP_LIBRARY_DIRS}")
