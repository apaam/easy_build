# variables: JSON_FOUND JSON_INCLUDE_DIRS

find_path(JSON_INCLUDE_DIRS nlohmann/json.hpp)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(JSON DEFAULT_MSG JSON_INCLUDE_DIRS)
mark_as_advanced(JSON_INCLUDE_DIRS)
