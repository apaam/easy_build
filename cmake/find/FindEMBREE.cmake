# variables: EMBREE_FOUND EMBREE_INCLUDE_DIRS EMBREE_LIBRARIES
# EMBREE_LIBRARY_DIRS

find_path(EMBREE_INCLUDE_DIR embree3/rtcore.h)
find_library(EMBREE_LIBRARY embree3)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EMBREE DEFAULT_MSG EMBREE_INCLUDE_DIR
                                  EMBREE_LIBRARY)
mark_as_advanced(EMBREE_INCLUDE_DIR EMBREE_LIBRARY)

if(EMBREE_FOUND)
  set(EMBREE_INCLUDE_DIRS ${EMBREE_INCLUDE_DIR})
  set(EMBREE_LIBRARIES ${EMBREE_LIBRARY})
endif()
