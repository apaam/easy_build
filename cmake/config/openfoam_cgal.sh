#----------------------------------*-sh-*--------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://openfoam.org
#   \\  /    A nd           | Copyright (C) 2014-2020 OpenFOAM Foundation
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This file is part of OpenFOAM.
#
#     OpenFOAM is free software: you can redistribute it and/or modify it
#     under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
#     ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#     FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#     for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.
#
# File
#     etc/config.sh/CGAL
#
# Description
#     Setup file for Boost and CGAL include.
#     Sourced during wmake process only.
#
#     If using system-wide installations use the following version settings:
#
#         boost_version=boost-system
#         cgal_version=cgal-system
#
# Note
#     A csh version is not needed, since the values here are only sourced
#     during the wmake process
#
#------------------------------------------------------------------------------

# boost_version=boost-system
# #boost_version=boost-1.55.0
# #boost_version=boost-1.72.0

# cgal_version=cgal-system
# #cgal_version=CGAL-4.10
# #cgal_version=CGAL-5.0.2

# if [ "$boost_version" != "boost-system" ]
# then
#     export BOOST_ARCH_PATH=$WM_THIRD_PARTY_DIR/$boost_version
# fi

# if [ "$cgal_version" != "cgal-system" ]
# then
#     export CGAL_ARCH_PATH=$WM_THIRD_PARTY_DIR/$cgal_version
# fi

export CGAL_ARCH_PATH=$WM_PROJECT_DIR/../../cgal/install

#------------------------------------------------------------------------------
