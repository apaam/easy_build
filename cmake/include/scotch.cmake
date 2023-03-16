message(STATUS "Configuring scotch ...")

if(SCOTCH_INCLUDED)
  return()
endif()
set(SCOTCH_INCLUDED TRUE)

if(USE_INTERNAL_SCOTCH)
  set(SCOTCH_EP_ROOT ${CONTRIB_ROOT_DIR}/contrib/scotch/ep)
  set(SCOTCH_SOURCE_DIR ${CONTRIB_ROOT_DIR}/contrib/scotch/src)
  set(SCOTCH_BUILD_DIR ${CONTRIB_ROOT_DIR}/contrib/scotch/src/src)
  set(SCOTCH_INSTALL_DIR ${CONTRIB_ROOT_DIR}/contrib/scotch/install)

  if(NOT EXISTS "${SCOTCH_SOURCE_DIR}/src/Makefile")
    message(SEND_ERROR "Submodule scotch missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  # ref: https://github.com/scivision/scotch-cmake/blob/main/cmake/scotch.cmake
  if(APPLE)
    if(CMAKE_C_COMPILER_ID STREQUAL GNU)
      set(scotch_cflags
          "-O3 -fPIC -Drestrict=__restrict -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_PTHREAD_BARRIER -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_TIMING_OLD -DSCOTCH_PTHREAD -DSCOTCH_RENAME"
      )
      set(scotch_ldflags "-lz -lm -lpthread")
    elseif(CMAKE_C_COMPILER_ID MATCHES Intel)
      set(scotch_cflags
          "-O3 -restrict -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_PTHREAD_BARRIER -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_TIMING_OLD -DSCOTCH_PTHREAD -DSCOTCH_RENAME"
      )
      set(scotch_ldflags "-lz -lm")
    endif()
  elseif(UNIX)
    if(CMAKE_C_COMPILER_ID STREQUAL GNU)
      set(scotch_cflags
          "-O3 -fPIC -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -Drestrict=__restrict -DIDXSIZE64"
      )
      set(scotch_ldflags "-lz -lm -lrt -pthread")
    elseif(CMAKE_C_COMPILER_ID MATCHES Intel)
      set(scotch_cflags
          "-O3 -DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -restrict -DIDXSIZE64"
      )
      set(scotch_ldflags "-lz -lm -lrt -pthread")
    endif()
  endif()

  find_program(MAKE_EXECUTABLE NAMES gmake make mingw32-make REQUIRED)
  configure_file(${CMAKE_SOURCE_DIR}/cmake/config/scotch_makefile.inc
                 ${SCOTCH_SOURCE_DIR}/src/Makefile.inc @ONLY)

  # to be revised
  ExternalProject_Add(
    SCOTCH
    PREFIX ${SCOTCH_EP_ROOT}
    SOURCE_DIR ${SCOTCH_SOURCE_DIR}
    BINARY_DIR ${SCOTCH_BUILD_DIR}
    INSTALL_DIR ${SCOTCH_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE_EXECUTABLE} -j${NUM_CORES} scotch ptscotch
    INSTALL_COMMAND ${MAKE_EXECUTABLE} -j${NUM_CORES} install
                    prefix=${SCOTCH_INSTALL_DIR})

  set(SCOTCH_INCLUDE_DIRS ${SCOTCH_INSTALL_DIR}/include)
  set(SCOTCH_LIBRARIES scotch ptscotch)
  set(SCOTCH_LIBRARY_DIRS ${SCOTCH_INSTALL_DIR}/lib)
else()
  find_package(SCOTCH)
  if(NOT SCOTCH_FOUND)
    message(SEND_ERROR "Can't find system scotch package.")
  endif()
endif()

set(SCOTCH_LIBRARIES ${SCOTCH_LIBRARIES})
include_directories(AFTER ${SCOTCH_INCLUDE_DIRS})
link_directories(AFTER ${SCOTCH_LIBRARY_DIRS})
message(STATUS "Using SCOTCH_INCLUDE_DIRS=${SCOTCH_INCLUDE_DIRS}")
message(STATUS "Using SCOTCH_LIBRARIES=${SCOTCH_LIBRARIES}")
message(STATUS "Using SCOTCH_LIBRARY_DIRS=${SCOTCH_LIBRARY_DIRS}")
