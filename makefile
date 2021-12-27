sync_submodule:
	git submodule sync

armadillo:
	git submodule update --depth 1 --init contrib/armadillo/src
	ARMADILLO=ON bash install.sh
arpack:
	git submodule update --depth 1 --init contrib/arpack/src
	ARPACK=ON bash install.sh	
cereal:
	git submodule update --depth 1 --init contrib/cereal/src
	CEREAL=ON bash install.sh	
cgal:
	git submodule update --depth 1 --init contrib/cgal/src
	CGAL=ON bash install.sh		
cork:
	git submodule update --depth 1 --init contrib/cork/src
	CORK=ON bash install.sh	
dealii: lapack trilinos petsc
	git submodule update --depth 1 --init contrib/dealii/src
	DEALII=ON bash install.sh
eigen:
	git submodule update --depth 1 --init contrib/eigen/src
	EIGEN=ON bash install.sh		
ensmallen:
	git submodule update --depth 1 --init contrib/ensmallen/src
	ENSMALLEN=ON bash install.sh		
flex:
	git submodule update --depth 1 --init contrib/flex/src
	FLEX=ON bash install.sh
gtest:
	git submodule update --depth 1 --init contrib/gtest/src
	GTEST=ON bash install.sh		
hdf5:
	git submodule update --depth 1 --init contrib/hdf5/src
	HDF5=ON bash install.sh
igl: cgal
	git submodule update --depth 1 --init contrib/igl/src
	IGL=ON bash install.sh	
json:
	git submodule update --depth 1 --init contrib/json/src
	JSON=ON bash install.sh		
lapack: 
	git submodule update --depth 1 --init contrib/lapack/src
	LAPACK=ON bash install.sh		
liggghts: vtk
	git submodule update --depth 1 --init contrib/liggghts/src
	LIGGGHTS=ON bash install.sh		
mfem:
	git submodule update --depth 1 --init contrib/mfem/src
	MFEM=ON bash install.sh
mlpack: armadillo ensmallen cereal
	git submodule update --depth 1 --init contrib/mlpack/src
	MLPACK=ON bash install.sh
netcdf:
	git submodule update --depth 1 --init contrib/netcdf/src
	NETCDF=ON bash install.sh
openblas:
	git submodule update --depth 1 --init contrib/openblas/src
	OPENBLAS=ON bash install.sh	
openfoam: flex scotch
	git submodule update --depth 1 --init contrib/openfoam/OpenFOAM-dev
	OPENFOAM=ON bash install.sh		
openmp: 
	git submodule update --depth 1 --init contrib/openmp/src
	OPENMP=ON bash install.sh			
peridigm: trilinos
	git submodule update --depth 1 --init contrib/peridigm/src
	PERIDIGM=ON bash install.sh	
petsc: petsc
	git submodule update --depth 1 --init contrib/petsc/src
	PETSC=ON bash install.sh		
scotch:
	git submodule update --depth 1 --init contrib/scotch/src
	SCOTCH=ON bash install.sh	
trilinos: lapack openblas netcdf hdf5 yaml
	git submodule update --depth 1 --init contrib/trilinos/src
	TRILINOS=ON bash install.sh	
vtk:
	git submodule update --depth 1 --init contrib/vtk/src
	VTK=ON bash install.sh	
yaml:
	git submodule update --depth 1 --init contrib/yaml/src
	YAML=ON bash install.sh	

netdem: mlpack mfem cork igl gtest eigen json openmp
	git submodule update --depth 1 --init contrib/netdem/src
	NETDEM=ON bash install.sh	

clean:
	rm -rvf build
realclean:
	rm -rvf build	
	rm -rvf contrib
	git checkout contrib

.PHONY: prepare hdf5 lapack liggghts netcdf netdem openblas peridigm trilinos \
	vtk yaml
