# variables: CGAL_FOUND CGAL_INCLUDE_DIRS CGAL_LIBRARIES CGAL_LIBRARY_DIRS

find_path(CGAL_INCLUDE_DIR CGAL/algorithm.h)
# find_library(CGAL_LIBRARIES CGAL_Core)
# find_path(CGAL_LIBRARY_DIRS CGAL_Core)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CGAL DEFAULT_MSG CGAL_INCLUDE_DIR)
mark_as_advanced(CGAL_INCLUDE_DIR)

if(CGAL_FOUND)
  set(CGAL_INCLUDE_DIRS ${CGAL_INCLUDE_DIR})
  # set(CGAL_LIBRARIES      ${CGAL_LIBRARY}) set(CGAL_LIBRARY_DIRS
  # ${CGAL_LIBRARY_DIR})
endif()
