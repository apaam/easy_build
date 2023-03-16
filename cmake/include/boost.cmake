message(STATUS "Configuring boost ...")

if(BOOST_INCLUDED)
  return()
endif()
set(BOOST_INCLUDED TRUE)

if(USE_INTERNAL_BOOST)
  message(
    SEND_ERROR "Setup steps for internal boost not defined yet. "
               "Please check ${CMAKE_SOURCE_DIR}/cmake/include/boost.cmake.")
else()
  find_package(Boost COMPONENTS math_tr1)
  if(NOT Boost_FOUND)
    message(SEND_ERROR "Can't find system boost package.")
  endif()

  set(BOOST_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
  set(BOOST_LIBRARIES ${Boost_LIBRARIES})
  set(BOOST_LIBRARY_DIRS ${Boost_LIBRARY_DIRS})
  set(BOOST_ROOT ${Boost_INCLUDE_DIRS}../)
endif()

message(STATUS "Using BOOST_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS}")
message(STATUS "Using BOOST_LIBRARIES=${BOOST_LIBRARIES}")
message(STATUS "Using BOOST_LIBRARY_DIRS=${BOOST_LIBRARY_DIRS}")
