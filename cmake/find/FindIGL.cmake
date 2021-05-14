# variables: IGL_FOUND IGL_INCLUDE_DIRS IGL_EXTERNAL_DIRS

find_path(IGL_INCLUDE_DIR igl/igl_inline.h)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IGL DEFAULT_MSG IGL_INCLUDE_DIR)
mark_as_advanced(IGL_INCLUDE_DIR)

if(IGL_FOUND)
  set(IGL_INCLUDE_DIRS ${IGL_INCLUDE_DIR})
  set(IGL_EXTERNAL_DIRS ${IGL_INCLUDE_DIR}/../external)
endif()
