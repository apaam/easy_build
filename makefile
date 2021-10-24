prepare:
	git submodule sync

hdf5:
	git submodule update --depth 1 --init contrib/hdf5/src
	HDF5=ON bash install.sh
lapack: 
	git submodule update --depth 1 --init contrib/lapack/src
	LAPACK=ON bash install.sh		
liggghts: vtk
	git submodule update --depth 1 --init contrib/liggghts/src
	LIGGGHTS=ON bash install.sh		
netcdf:
	git submodule update --depth 1 --init contrib/netcdf/src
	NETCDF=ON bash install.sh
openblas:
	git submodule update --depth 1 --init contrib/openblas/src
	OPENBLAS=ON bash install.sh	
peridigm: trilinos
	git submodule update --depth 1 --init contrib/peridigm/src
	PERIDIGM=ON bash install.sh	
trilinos: lapack openblas netcdf hdf5 yaml
	git submodule update --depth 1 --init contrib/trilinos/src
	TRILINOS=ON bash install.sh	
vtk:
	git submodule update --depth 1 --init contrib/vtk/src
	VTK=ON bash install.sh	
yaml:
	git submodule update --depth 1 --init contrib/yaml/src
	YAML=ON bash install.sh	

netdem:
	git submodule update --depth 1 --init contrib/armadillo/src
	git submodule update --depth 1 --init contrib/arpack/src
	git submodule update --depth 1 --init contrib/cereal/src
	git submodule update --depth 1 --init contrib/cgal/src
	git submodule update --depth 1 --init contrib/cork/src
	git submodule update --depth 1 --init contrib/eigen/src
	git submodule update --depth 1 --init contrib/ensmallen/src
	git submodule update --depth 1 --init contrib/gtest/src
	git submodule update --depth 1 --init contrib/igl/src
	git submodule update --depth 1 --init contrib/json/src
	git submodule update --depth 1 --init contrib/lapack/src
	git submodule update --depth 1 --init contrib/mlpack/src
	git submodule update --depth 1 --init contrib/mpfr/src
	git submodule update --depth 1 --init contrib/openblas/src
	git submodule update --depth 1 --init contrib/openmp/src
	git submodule update --depth 1 --init contrib/stb/src
	git submodule update --depth 1 --init contrib/netdem/src
	NETDEM=ON bash install.sh	

.PHONY: prepare
