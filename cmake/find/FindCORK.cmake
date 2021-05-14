# variables: CORK_FOUND CORK_INCLUDE_DIRS CORK_LIBRARIES CORK_LIBRARY_DIRS

find_path(CORK_INCLUDE_DIR cork.h)
find_library(CORK_LIBRARY cork)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CORK DEFAULT_MSG CORK_INCLUDE_DIR
                                  CORK_LIBRARY)
mark_as_advanced(CORK_INCLUDE_DIR CORK_LIBRARY)

if(CORK_FOUND)
  set(CORK_INCLUDE_DIRS
      ${CORK_INCLUDE_DIR}
      ${CORK_INCLUDE_DIR}/accel
      ${CORK_INCLUDE_DIR}/file_formats
      ${CORK_INCLUDE_DIR}/isct
      ${CORK_INCLUDE_DIR}/math
      ${CORK_INCLUDE_DIR}/mesh
      ${CORK_INCLUDE_DIR}/rawmesh
      ${CORK_INCLUDE_DIR}/util)
  set(CORK_LIBRARIES ${CORK_LIBRARY})
endif()
