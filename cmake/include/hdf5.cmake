message(STATUS "Configuring hdf5 ...")

if(HDF5_INCLUDED)
  return()
endif()
set(HDF5_INCLUDED TRUE)

if(USE_INTERNAL_HDF5)
  set(HDF5_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/hdf5/ep)
  set(HDF5_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/hdf5/src)
  set(HDF5_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/hdf5/build)
  set(HDF5_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/hdf5/install)

  if(NOT EXISTS "${HDF5_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule hdf5 missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    HDF5
    PREFIX ${HDF5_EP_ROOT}
    SOURCE_DIR ${HDF5_SOURCE_DIR}
    BINARY_DIR ${HDF5_BUILD_DIR}
    INSTALL_DIR ${HDF5_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake -DCMAKE_INSTALL_PREFIX=${HDF5_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${MPICXX_COMPILER}
      -DCMAKE_C_COMPILER=${MPICC_COMPILER} -DHDF5_ENABLE_PARALLEL=ON
      -DDEFAULT_API_VERSION=v18 -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF
      ${HDF5_SOURCE_DIR}
    BUILD_COMMAND make -j${NUM_CORES}
    INSTALL_COMMAND make -j${NUM_CORES} install)

  set(HDF5_INCLUDE_DIRS ${HDF5_INSTALL_DIR}/include)
  set(HDF5_LIBRARIES hdf5 hdf5_hl hdf5_tools)
  set(HDF5_C_LIBRARY hdf5)
  set(HDF5_HL_LIBRARY hdf5_hl)
  set(HDF5_LIBRARY_DIRS ${HDF5_INSTALL_DIR}/lib)
else()
  find_package(HDF5)
  if(NOT HDF5_FOUND)
    message(SEND_ERROR "Can't find system hdf5 package.")
  endif()
endif()

set(HDF5_LIBRARIES ${HDF5_LIBRARIES})
include_directories(AFTER ${HDF5_INCLUDE_DIRS})
link_directories(AFTER ${HDF5_LIBRARY_DIRS})
message(STATUS "Using HDF5_INCLUDE_DIRS=${HDF5_INCLUDE_DIRS}")
message(STATUS "Using HDF5_LIBRARIES=${HDF5_LIBRARIES}")
message(STATUS "Using HDF5_LIBRARY_DIRS=${HDF5_LIBRARY_DIRS}")
