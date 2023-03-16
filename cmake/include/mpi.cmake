message(STATUS "Configuring MPI ...")

if(MPI_INCLUDED)
  return()
endif()
set(MPI_INCLUDED TRUE)

if(USE_INTERNAL_MPI)
  message(
    SEND_ERROR "Setup steps for internal mpi not defined yet. "
               "Please check ${CMAKE_SOURCE_DIR}/cmake/include/mpi.cmake.")
else()
  find_package(MPI)
  if(NOT MPI_FOUND)
    message(SEND_ERROR "Can't find system mpi package.")
  endif()

  set(MPI_INCLUDE_DIRS ${MPI_CXX_INCLUDE_DIRS} ${MPI_C_INCLUDE_DIRS})
  set(MPI_LIBRARIES ${MPI_CXX_LIBRARIES} ${MPI_C_LIBRARIES})
endif()

message(STATUS "Using MPI_INCLUDE_DIRS=${MPI_INCLUDE_DIRS}")
message(STATUS "Using MPI_LIBRARIES=${MPI_LIBRARIES}")
