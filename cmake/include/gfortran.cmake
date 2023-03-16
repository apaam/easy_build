message(STATUS "Configuring gfortran ...")

if(GFORTRAN_INCLUDED)
  return()
endif()
set(GFORTRAN_INCLUDED TRUE)

if(USE_INTERNAL_GFORTRAN)
  message(
    SEND_ERROR "Setup steps for internal gfortran not defined yet. "
               "Please check ${CMAKE_SOURCE_DIR}/cmake/include/gfortran.cmake.")
else()
  # find_package(GFORTRAN) does not work for linux, need to improve 
  if(APPLE)
    find_package(GFORTRAN)
    if(NOT GFORTRAN_FOUND)
      message(SEND_ERROR "Can't find system gfortran package.")
    endif()
  else()
    set(GFORTRAN_LIBRARIES gfortran)
  endif()
endif()

message(STATUS "Using GFORTRAN_INCLUDE_DIRS=${GFORTRAN_INCLUDE_DIRS}")
message(STATUS "Using GFORTRAN_LIBRARIES=${GFORTRAN_LIBRARIES}")
message(STATUS "Using GFORTRAN_LIBRARY_DIRS=${GFORTRAN_LIBRARY_DIRS}")
