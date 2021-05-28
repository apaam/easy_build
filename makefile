prepare:
	git submodule sync
peridigm:
	git submodule update --depth 1 --init contrib/lapack/src
	git submodule update --depth 1 --init contrib/hdf5/src
	git submodule update --depth 1 --init contrib/netcdf/src
	git submodule update --depth 1 --init contrib/yaml/src
	git submodule update --depth 1 --init contrib/trilinos/src
	git submodule update --depth 1 --init contrib/peridigm/src
	PERIDIGM=ON bash install.sh
liggghts:
	git submodule update --depth 1 --init contrib/vtk/src
	git submodule update --depth 1 --init contrib/liggghts/src
	LIGGGHTS=ON bash install.sh	
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
