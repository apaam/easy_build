message(STATUS "Configuring gtest ...")

if(GTEST_INCLUDED)
  return()
endif()
set(GTEST_INCLUDED TRUE)

if(USE_INTERNAL_GTEST)
  set(GTEST_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/gtest/ep)
  set(GTEST_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/gtest/src)
  set(GTEST_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/gtest/build)
  set(GTEST_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/gtest/install)

  if(NOT EXISTS "${GTEST_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule gtest missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    GTEST
    PREFIX ${GTEST_EP_ROOT}
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
  set(GTEST_LIBRARY_DIRS ${GTEST_INSTALL_DIR}/lib)
  set(GTEST_MAIN_LIBRARIES gtest_main)
  set(GTEST_LIBRARIES gtest)
  set(GTEST_BOTH_LIBRARIES ${GTEST_MAIN_LIBRARIES} ${GTEST_LIBRARIES})
else()
  find_package(GTest)
  if(NOT GTEST_FOUND)
    message(SEND_ERROR "Can't find system gtest package.")
  endif()
endif()

include_directories(AFTER ${GTEST_INCLUDE_DIRS})
link_directories(AFTER ${GTEST_LIBRARY_DIRS})
message(STATUS "Using GTEST_INCLUDE_DIRS=${GTEST_INCLUDE_DIRS}")
message(STATUS "Using GTEST_BOTH_LIBRARIES=${GTEST_BOTH_LIBRARIES}")
message(STATUS "Using GTEST_LIBRARY_DIRS=${GTEST_LIBRARY_DIRS}")
