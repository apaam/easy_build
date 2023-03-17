message(STATUS "Configuring json ...")

if(JSON_INCLUDED)
  return()
endif()
set(JSON_INCLUDED TRUE)

if(USE_INTERNAL_JSON)
  set(JSON_EP_ROOT ${CONTRIB_ROOT_DIR}/json/ep)
  set(JSON_SOURCE_DIR ${CONTRIB_ROOT_DIR}/json/src)
  set(JSON_BUILD_DIR ${CONTRIB_ROOT_DIR}/json/build)
  set(JSON_INSTALL_DIR ${CONTRIB_ROOT_DIR}/json/install)

  if(NOT EXISTS "${JSON_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule json missing. To fix, try run: "
                       "git submodule update --init")
  endif()

  ExternalProject_Add(
    JSON
    PREFIX ${JSON_EP_ROOT}
    SOURCE_DIR ${JSON_SOURCE_DIR}
    BINARY_DIR ${JSON_BUILD_DIR}
    INSTALL_DIR ${JSON_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${JSON_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DJSON_BuildTests=OFF ${JSON_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(JSON_INCLUDE_DIRS ${JSON_INSTALL_DIR}/include)
else()
  find_package(JSON)
  if(NOT JSON_FOUND)
    message(SEND_ERROR "Can't find system json package.")
  endif()
endif()

message(STATUS "Using JSON as heads only package")
message(STATUS "Using JSON_INCLUDE_DIRS=${JSON_INCLUDE_DIRS}")
