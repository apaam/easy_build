#!/bin/bash

cp @CMAKE_SOURCE_DIR@/cmake/config/openfoam_scotch.sh \
   @OPENFOAM_SOURCE_DIR@/etc/config.sh/scotch
cp @CMAKE_SOURCE_DIR@/cmake/config/openfoam_cgal.sh \
   @OPENFOAM_SOURCE_DIR@/etc/config.sh/CGAL
cd @OPENFOAM_SOURCE_DIR@
source ./etc/bashrc
./Allwmake -j@NUM_CORES@
