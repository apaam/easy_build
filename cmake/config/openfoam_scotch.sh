#----------------------------------*-sh-*--------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://openfoam.org
#   \\  /    A nd           | Copyright (C) 2011-2020 OpenFOAM Foundation
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
#     etc/config.sh/scotch
#
# Description
#     Setup file for scotch include/libraries.
#     Sourced during wmake process only.
#
# Note
#     A csh version is not needed, since the values here are only sourced
#     during the wmake process
#
#     If Scotch is to be entirely disabled, either rename this file or create
#     an empty one with the same name at a user or site location.
#
#------------------------------------------------------------------------------

export SCOTCH_VERSION=scotch_6.0.9
export SCOTCH_ARCH_PATH=$WM_PROJECT_DIR/../../scotch/install

#------------------------------------------------------------------------------
