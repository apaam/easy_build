Welcome to EasyBuild!
================

**EasyBuild** provides a collection of third-party open-source libraries and softwares in computational mechanics. It aims at easing the complex configuring, building and installing processes of these computational packages, and thus helping researchers to get a quick start. 

### 1. To install a package

 0. Prerequisites: gcc, autoconf, automake, cmake, mpi, boost.

   - For **MacOS**: use ``brew install``, such as

       ```
       brew install gcc autoconf automake cmake mpi boost
       ```

   - For **Ubuntu**: use ``apt-get install``, such as

       ```
       sudo apt install build-essential
       sudo apt-get install -y autoconf-archive automake cmake texinfo
       sudo apt-get install openmpi-bin libopenmpi-dev libboost-all-dev
       ```

 1. Configure, build and install:

    ```
    make prepare
    make [package]
    ```

### 2. To add a new package

1. Create the submodule using:

    ```    
    git submodule add --depth 1 [package_source_url] contrib/[package]/src
    ```
2. Insert an entry of the package in file *makefile*, following the format of existing packages.

3. Insert an entry of the package in file *install.sh*. Two modifications will be needed.

    ```
    PACKAGE=${PACKAGE:-OFF}         \\ around line 12
    ```
    ```
    -DENABLE_PACKAGE=${PACKAGE}     \\ around line 30 in the cmake command
    ```

4. Modify *CMakeLists.txt* by adding configuring options for the package.

    ```
    option(USE_INTERNAL_[PACKAGE] "use internal [package]" ON)
    option(USE_INTERNAL_[PACKAGE_DEPENDENCY] "use internal [package_denpendency]" ON)
    ```
    ```
    option(ENABLE_[PACKAGE] "build [package]" OFF)
    if(ENABLE_[PACKAGE])
      include(cmake/include/[package].cmake)

      if(USE_INTERNAL_[PACKAGE])
        add_dependencies(${PROJECT_NAME} [PACKAGE])
      endif()
    endif()
    ```

5. Create file *[package].cmake*, as well as the *[package_dependency].cmake* inside *cmake/include*, and implement the configure, build and installation procedures. (one can make a copy of the cmake file of existing packages and make modifications on that). This step is the most complex one, and one should refer to the installation procedure of a specific package.

6. Add a description of the package in *readme.md*.

Note: a dependency of the existing packages can be a standalone package as well. One can make them exiplicit by following the aformentioned procedures, it there is an interest. In this case, the steps of *1) create submodule* and *5) create cmake files* are not required, minor modifications (e.g., the path, configurations) in the cmake files might be needed though.

### 3. Support

Supported packages are added based on needs. If you need packages that are not on the list, or would like to contribute by adding them, please [open an issue](https://github.com/net-dem/easy_build/issues) or [submit a pull request](https://github.com/net-dem/easy_build/pulls).

### 4. Supported packages

[peridigm](https://github.com/peridigm/peridigm.git): an open-source computational peridynamics code developed, originally at Sandia National Laboratories and open-sourced in 2011, for massively-parallel multi-physics simulations.

[liggghts](https://github.com/CFDEMproject/LIGGGHTS-PUBLIC.git): an open source discrete element method particle simulation software that is improved from LAMMPS for general granular and granular heat transfer simulations.

[netdem](https://github.com/net-dem/netdem.git): a neural network machine learning enabled DEM framework for computational particle mechanics.