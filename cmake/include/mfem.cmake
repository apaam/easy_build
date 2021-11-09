message(STATUS "Configuring mfem ...")

if(MFEM_INCLUDED)
  return()
endif()
set(MFEM_INCLUDED TRUE)

if(USE_INTERNAL_MFEM)
  set(MFEM_EP_ROOT ${CONTRIB_ROOT_DIR}/mfem/ep)
  set(MFEM_SOURCE_DIR ${CONTRIB_ROOT_DIR}/mfem/src)
  set(MFEM_BUILD_DIR ${CONTRIB_ROOT_DIR}/mfem/build)
  set(MFEM_INSTALL_DIR ${CONTRIB_ROOT_DIR}/mfem/install)

  if(NOT EXISTS "${MFEM_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule mfem missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    MFEM
    PREFIX ${MFEM_EP_ROOT}
    SOURCE_DIR ${MFEM_SOURCE_DIR}
    BINARY_DIR ${MFEM_BUILD_DIR}
    INSTALL_DIR ${MFEM_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${MFEM_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${MFEM_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(MFEM_INCLUDE_DIRS ${MFEM_INSTALL_DIR}/include)
  set(MFEM_LIBRARIES libmfem.a)
  set(MFEM_LIBRARY_DIRS ${MFEM_INSTALL_DIR}/lib)
else()
  find_package(MFEM)
  if(NOT MFEM_FOUND)
    message(SEND_ERROR "Can't find system mfem package.")
  endif()
endif()

set(MFEM_LIBRARIES ${MFEM_LIBRARIES})
include_directories(AFTER ${MFEM_INCLUDE_DIRS})
link_directories(AFTER ${MFEM_LIBRARY_DIRS})
message(STATUS "Using MFEM_INCLUDE_DIRS=${MFEM_INCLUDE_DIRS}")
message(STATUS "Using MFEM_LIBRARIES=${MFEM_LIBRARIES}")
message(STATUS "Using MFEM_LIBRARY_DIRS=${MFEM_LIBRARY_DIRS}")
