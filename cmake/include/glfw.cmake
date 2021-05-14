message(STATUS "Configuring glfw ...")

if(GLFW_INCLUDED)
  return()
endif()
set(GLFW_INCLUDED TRUE)

if(USE_INTERNAL_GLFW)
  set(GLFW_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/glfw/ep)
  set(GLFW_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/glfw/src)
  set(GLFW_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/glfw/build)
  set(GLFW_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/glfw/install)

  if(NOT EXISTS "${GLFW_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule glfw missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    GLFW
    PREFIX ${GLFW_EP_ROOT}
    SOURCE_DIR ${GLFW_SOURCE_DIR}
    BINARY_DIR ${GLFW_BUILD_DIR}
    INSTALL_DIR ${GLFW_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_LIBDIR=${GLFW_INSTALL_DIR}/lib
      -DCMAKE_INSTALL_INCLUDEDIR=${GLFW_INSTALL_DIR}/include
      -DBUILD_SHARED_LIBS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF
      -DGLFW_BUILD_DOCS=OFF -DGLFW_INSTALL=ON ${GLFW_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  set(GLFW_INCLUDE_DIRS ${GLFW_INSTALL_DIR}/include)
  set(GLFW_LIBRARIES glfw)
  set(GLFW_LIBRARY_DIRS ${GLFW_INSTALL_DIR}/lib)
else()
  find_package(GLFW)
  if(NOT GLFW_FOUND)
    message(SEND_ERROR "Can't find system glfw package.")
  endif()
endif()

set(GLFW_LIBRARIES ${GLFW_LIBRARIES})
include_directories(AFTER ${GLFW_INCLUDE_DIRS})
link_directories(AFTER ${GLFW_LIBRARY_DIRS})
message(STATUS "Using GLFW_INCLUDE_DIRS=${GLFW_INCLUDE_DIRS}")
message(STATUS "Using GLFW_LIBRARIES=${GLFW_LIBRARIES}")
message(STATUS "Using GLFW_LIBRARY_DIRS=${GLFW_LIBRARY_DIRS}")
