message(STATUS "Configuring vtk ...")

if(VTK_INCLUDED)
  return()
endif()
set(VTK_INCLUDED TRUE)

if(USE_INTERNAL_VTK)
  set(VTK_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/vtk/ep)
  set(VTK_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/vtk/src)
  set(VTK_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/vtk/build)
  set(VTK_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/vtk/install)

  if(NOT EXISTS "${VTK_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule vtk missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    VTK
    PREFIX ${VTK_EP_ROOT}
    SOURCE_DIR ${VTK_SOURCE_DIR}
    BINARY_DIR ${VTK_BUILD_DIR}
    INSTALL_DIR ${VTK_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${VTK_INSTALL_DIR}
      -DBUILD_SHARED_LIBS=OFF -DVTK_USE_MPI=ON
      -DCMAKE_CXX_COMPILER=${MPI_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${MPI_C_COMPILER} ${VTK_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(VTK_INCLUDE_DIRS ${VTK_INSTALL_DIR}/include/vtk-9.0)
  set(VTK_LIBRARIES vtk)
  set(VTK_LIBRARY_DIRS ${VTK_INSTALL_DIR}/lib)
else()
  find_package(VTK)
  if(NOT VTK_FOUND)
    message(SEND_ERROR "Can't find system vtk package.")
  endif()
endif()

include_directories(AFTER ${VTK_INCLUDE_DIRS})
link_directories(AFTER ${VTK_LIBRARY_DIRS})
message(STATUS "Using VTK_INCLUDE_DIRS=${VTK_INCLUDE_DIRS}")
message(STATUS "Using VTK_LIBRARIES=${VTK_LIBRARIES}")
message(STATUS "Using VTK_LIBRARY_DIRS=${VTK_LIBRARY_DIRS}")
