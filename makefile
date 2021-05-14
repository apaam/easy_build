prepare:
	git submodule sync
peridigm:
	git submodule update --depth 1 --init --recursive contrib/lapack/src
	git submodule update --depth 1 --init --recursive contrib/hdf5/src
	git submodule update --depth 1 --init --recursive contrib/netcdf/src
	git submodule update --depth 1 --init --recursive contrib/yaml/src
	git submodule update --depth 1 --init --recursive contrib/trilinos/src
	git submodule update --depth 1 --init --recursive contrib/peridigm/src
	PERIDIGM=ON bash install.sh

.PHONY: prepare
