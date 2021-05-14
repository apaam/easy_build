# variables: TBB_FOUND TBB_INCLUDE_DIRS TBB_LIBRARIES TBB_LIBRARY_DIRS

find_path(TBB_INCLUDE_DIR tbb/tbb.h)
find_library(TBB_LIBRARY tbb)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TBB DEFAULT_MSG TBB_INCLUDE_DIR TBB_LIBRARY)
mark_as_advanced(TBB_INCLUDE_DIR TBB_LIBRARY)

if(TBB_FOUND)
  set(TBB_INCLUDE_DIRS ${TBB_INCLUDE_DIR})
  set(TBB_LIBRARIES ${TBB_LIBRARY})
endif()
