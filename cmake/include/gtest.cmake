message(STATUS "Configuring gtest ...")

if(GTEST_INCLUDED)
  return()
endif()
set(GTEST_INCLUDED TRUE)

if(USE_INTERNAL_GTEST)
  set(GTEST_EP_DIR ${CONTRIB_ROOT_DIR}/gtest/ep)
  set(GTEST_SOURCE_DIR ${CONTRIB_ROOT_DIR}/gtest/src)
  set(GTEST_BUILD_DIR ${CONTRIB_ROOT_DIR}/gtest/build)
  set(GTEST_INSTALL_DIR ${CONTRIB_ROOT_DIR}/gtest/install)

  if(NOT EXISTS "${GTEST_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule gtest missing. To fix, try run: "
                       "make sync_submodule")
  endif()

  ExternalProject_Add(
    GTEST
    PREFIX ${GTEST_EP_DIR}
    SOURCE_DIR ${GTEST_SOURCE_DIR}
    BINARY_DIR ${GTEST_BUILD_DIR}
    INSTALL_DIR ${GTEST_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${GTEST_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${GTEST_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(GTEST_INCLUDE_DIRS ${GTEST_INSTALL_DIR}/include)
  set(GTEST_LIBRARIES gtest_main gtest)
  set(GTEST_LIBRARY_DIRS ${GTEST_INSTALL_DIR}/lib)
else()
  find_package(GTest)
  if(NOT GTEST_FOUND)
    message(SEND_ERROR "Can't find system gtest package.")
  endif()
  set(GTEST_LIBRARIES ${GTEST_LIBRARIES})
endif()

message(STATUS "Using GTEST_INCLUDE_DIRS=${GTEST_INCLUDE_DIRS}")
message(STATUS "Using GTEST_LIBRARIES=${GTEST_LIBRARIES}")
message(STATUS "Using GTEST_LIBRARY_DIRS=${GTEST_LIBRARY_DIRS}")
