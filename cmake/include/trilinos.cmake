message(STATUS "Configuring trilinos ...")

if(TRILINOS_INCLUDED)
  return()
endif()
set(TRILINOS_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/include/mpi.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/lapack.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/hdf5.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/netcdf.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/include/yaml.cmake)

if(USE_INTERNAL_TRILINOS)
  set(TRILINOS_EP_ROOT ${CMAKE_SOURCE_DIR}/contrib/trilinos/ep)
  set(TRILINOS_SOURCE_DIR ${CMAKE_SOURCE_DIR}/contrib/trilinos/src)
  set(TRILINOS_BUILD_DIR ${CMAKE_SOURCE_DIR}/contrib/trilinos/build)
  set(TRILINOS_INSTALL_DIR ${CMAKE_SOURCE_DIR}/contrib/trilinos/install)
  set(TMP_C_FLAGS "-O2 -std=c++14 -pedantic -ftrapv -Wall -Wno-long-long")
  set(TMP_CXX_FLAGS "-O2 -std=c++14 -pedantic -ftrapv -Wall -Wno-long-long")

  if(NOT EXISTS "${TRILINOS_SOURCE_DIR}/CMakeLists.txt")
    message(SEND_ERROR "Submodule trilinos missing. To fix, try run: "
                       "git submodule update --init --recursive")
  endif()

  ExternalProject_Add(
    TRILINOS
    PREFIX ${TRILINOS_EP_ROOT}
    SOURCE_DIR ${TRILINOS_SOURCE_DIR}
    BINARY_DIR ${TRILINOS_BUILD_DIR}
    INSTALL_DIR ${TRILINOS_INSTALL_DIR}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
    LOG_OUTPUT_ON_FAILURE TRUE
    CONFIGURE_COMMAND
      cmake ${CMAKE_GENERATOR_FLAG}
      -DCMAKE_INSTALL_PREFIX=${TRILINOS_INSTALL_DIR}
      -DCMAKE_CXX_COMPILER=${MPICXX_COMPILER}
      -DCMAKE_C_COMPILER=${MPICC_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${TMP_C_FLAGS} -DCMAKE_BUILD_TYPE:STRING=RELEASE
      -DTrilinos_WARNINGS_AS_ERRORS_FLAGS:STRING=""
      -DTrilinos_ENABLE_ALL_PACKAGES=OFF -DTrilinos_ENABLE_Teuchos=ON
      -DTrilinos_ENABLE_Shards=ON -DTrilinos_ENABLE_Sacado=ON
      -DTrilinos_ENABLE_Epetra=ON -DTrilinos_ENABLE_EpetraExt=ON
      -DTrilinos_ENABLE_Ifpack=ON -DTrilinos_ENABLE_AztecOO=ON
      -DTrilinos_ENABLE_Amesos=ON -DTrilinos_ENABLE_Anasazi=ON
      -DTrilinos_ENABLE_Belos=ON -DTrilinos_ENABLE_ML=ON
      -DTrilinos_ENABLE_Phalanx=ON -DTrilinos_ENABLE_Intrepid=ON
      -DTrilinos_ENABLE_NOX=ON -DTrilinos_ENABLE_Stratimikos=ON
      -DTrilinos_ENABLE_Thyra=ON -DTrilinos_ENABLE_Rythmos=ON
      -DTrilinos_ENABLE_MOOCHO=ON -DTrilinos_ENABLE_TriKota=OFF
      -DTrilinos_ENABLE_Stokhos=ON -DTrilinos_ENABLE_Zoltan=ON
      -DTrilinos_ENABLE_Piro=ON -DTrilinos_ENABLE_Teko=ON
      -DTrilinos_ENABLE_SEACASIoss=ON -DTrilinos_ENABLE_SEACAS=ON
      -DTrilinos_ENABLE_SEACASBlot=OFF -DTrilinos_ENABLE_Pamgen=ON
      -DTrilinos_ENABLE_EXAMPLES=OFF -DTrilinos_ENABLE_TESTS=OFF
      -DTPL_ENABLE_HDF5=ON -DHDF5_INCLUDE_DIRS=${HDF5_INCLUDE_DIRS}
      -DHDF5_LIBRARY_DIRS=${HDF5_LIBRARY_DIRS} -DTPL_ENABLE_Netcdf=ON
      -DTPL_Netcdf_Enables_Netcdf4=ON
      -DNetcdf_INCLUDE_DIRS=${NETCDF_INCLUDE_DIRS}
      -DNetcdf_LIBRARY_DIRS=${NETCDF_LIBRARY_DIRS} -DTPL_ENABLE_MPI=ON
      -DMPI_BASE_DIR=${MPI_INCLUDE_DIRS}/../ -DTPL_ENABLE_BLAS=ON
      -DTPL_ENABLE_LAPACK=ON -DLAPACK_INCLUDE_DIRS=${LAPACK_INCLUDE_DIRS}
      -DLAPACK_LIBRARY_DIRS=${LAPACK_LIBRARY_DIRS} -DTPL_ENABLE_Boost=ON
      -DBoost_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS}
      -DBoost_LIBRARY_DIRS=${BOOST_LIBRARY_DIRS} -DTPL_ENABLE_yaml-cpp=ON
      -DTPL_yaml-cpp_INCLUDE_DIRS=${YAML_INCLUDE_DIRS}
      -DTPL_yaml-cpp_LIBRARIES=${YAML_LIBRARIES}
      -DTPL_yaml-cpp_LIBRARY_DIRS=${YAML_LIBRARY_DIRS}
      -DCMAKE_VERBOSE_MAKEFILE=OFF -DTrilinos_VERBOSE_CONFIGURE=OFF
      -DTPL_ENABLE_Matio=OFF -DTPL_ENABLE_X11=OFF ${TRILINOS_SOURCE_DIR}
    BUILD_COMMAND ${GENERATOR} -j${NUM_CORES}
    INSTALL_COMMAND ${GENERATOR} -j${NUM_CORES} install)

  if(USE_INTERNAL_HDF5)
    add_dependencies(TRILINOS HDF5)
  endif(USE_INTERNAL_HDF5)

  if(USE_INTERNAL_NETCDF)
    add_dependencies(TRILINOS NETCDF)
  endif(USE_INTERNAL_NETCDF)

  if(USE_INTERNAL_YAML)
    add_dependencies(TRILINOS YAML)
  endif(USE_INTERNAL_YAML)

  set(TRILINOS_INCLUDE_DIRS ${TRILINOS_INSTALL_DIR}/include)
  set(TRILINOS_LIBRARIES trilinos)
  set(TRILINOS_LIBRARY_DIRS ${TRILINOS_INSTALL_DIR}/lib)
else()
  find_package(TRILINOS)
  if(NOT TRILINOS_FOUND)
    message(SEND_ERROR "Can't find system trilinos package.")
  endif()
endif()

set(TRILINOS_LIBRARIES ${TRILINOS_LIBRARIES} ${HDF5_LIBRARIES}
                       ${NETCDF_LIBRARIES} ${BOOST_LIBRARIES} ${YAML_LIBRARIES})
include_directories(AFTER ${TRILINOS_INCLUDE_DIRS})
link_directories(AFTER ${TRILINOS_LIBRARY_DIRS})
message(STATUS "Using TRILINOS_INCLUDE_DIRS=${TRILINOS_INCLUDE_DIRS}")
message(STATUS "Using TRILINOS_LIBRARIES=${TRILINOS_LIBRARIES}")
message(STATUS "Using TRILINOS_LIBRARY_DIRS=${TRILINOS_LIBRARY_DIRS}")
