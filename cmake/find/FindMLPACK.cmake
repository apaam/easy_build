# variables: MLPACK_FOUND MLPACK_INCLUDE_DIRS MLPACK_LIBRARIES
# MLPACK_LIBRARY_DIRS

find_path(MLPACK_INCLUDE_DIR mlpack/core.hpp)
find_library(MLPACK_LIBRARY mlpack)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MLPACK DEFAULT_MSG MLPACK_INCLUDE_DIR
                                  MLPACK_LIBRARY)
mark_as_advanced(MLPACK_INCLUDE_DIR MLPACK_LIBRARY)

if(MLPACK_FOUND)
  set(MLPACK_INCLUDE_DIRS ${MLPACK_INCLUDE_DIR})
  set(MLPACK_LIBRARIES ${MLPACK_LIBRARY})
endif()
