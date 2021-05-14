message(STATUS "Configuring yaml ...")

if(YAML_INCLUDED)
  return()
endif()
set(YAML_INCLUDED TRUE)

if(USE_INTERNAL_YAML)
  set(YAML_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/yaml/ep)
  set(YAML_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/yaml/src)
  set(YAML_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/yaml/build)
  set(YAML_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/yaml/install)

  if(NOT EXISTS "${YAML_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule yaml missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    YAML
    PREFIX ${YAML_EP_ROOT}
    SOURCE_DIR ${YAML_SOURCE_DIR}
    BINARY_DIR ${YAML_BUILD_DIR}
    INSTALL_DIR ${YAML_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG} -DCMAKE_INSTALL_PREFIX=${YAML_INSTALL_DIR}
      -DYAML_CPP_BUILD_TESTS=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${YAML_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(YAML_INCLUDE_DIRS ${YAML_INSTALL_DIR}/include)
  set(YAML_LIBRARIES yaml-cpp)
  set(YAML_LIBRARY_DIRS ${YAML_INSTALL_DIR}/lib)
else()
  find_package(YAML)
  if(NOT YAML_FOUND)
    message(SEND_ERROR "Can't find system yaml package.")
  endif()
endif()

include_directories(AFTER ${YAML_INCLUDE_DIRS})
link_directories(AFTER ${YAML_LIBRARY_DIRS})
message(STATUS "Using YAML_INCLUDE_DIRS=${YAML_INCLUDE_DIRS}")
