Welcome to EasyBuild!
================

**EasyBuild** provides a collection of third-party open-source libraries and softwares in computational mechanics. It aims at easing the complex configuring, building and installing processes of these computational packages, and thus helping researchers to get a quick start. 

### 1. Supported packages

[peridigm](https://github.com/peridigm/peridigm.git): an open-source computational peridynamics code developed, originally at Sandia National Laboratories and open-sourced in 2011, for massively-parallel multi-physics simulations.

### 2. Installation

 1. Prerequisites: gcc, autoconf, automake, cmake, mpi, boost.

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

 2. Configure, build and install:

    ```
    make [package]
    ```

### 3. Support

Supported packages are added based on needs. If you need packages that are not on the list, or would like to contribute by adding them, please [open an issue](https://github.com/net-dem/easy_build/issues) or [submit a pull request](https://github.com/net-dem/easy_build/pulls).