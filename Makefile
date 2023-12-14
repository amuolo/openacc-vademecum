##################################
# Makefile for Openacc Vademecum #
##################################

#
# Compiler
#
CC = g++ 

#
# Paths
#
ARMA = /home/$(USER)/installs/armadillo-11.0
BOOST = /home/$(USER)/installs/boost_1_80_0
BLAS = /home/$(USER)/installs/OpenBLAS

#
# Compilation Macros
#
PREPROC = -DARMA_DONT_USE_WRAPPER -DARMA_DONT_USE_HDF5 -DARMA_DONT_USE_OPENMP -DARMA_USE_LAPACK -DARMA_USE_BLAS -DARMA_USE_NEWARP -DARMA_NO_DEBUG

INCLUDE = -I$(BLAS)/include -I$(ARMA)/include -I$(ARMA)/include/armadillo_bits -I$(BOOST)/include

CFLAGS = -g3 -Wall -c -m64 -fmessage-length=0 -pthread -fopenmp -fopenmp-simd -std=gnu++17 -fopenacc

#
# Linking Macros
#
LFLAGS = -static -static-libstdc++ -static-libgcc -foffload=-lm -pthread -fopenmp -fopenmp-simd -std=gnu++17 -fopenacc #-acc -ta=nvidia -Minfo=accel

LIBS = -ldl -lrt -lm -lz -lopenblaso64 -lgfortran -lquadmath -lboost_system -lboost_mpi -lboost_serialization

USER_LIBS = -L/home/andoras/installs/OpenBLAS/lib -L/home/andoras/installs/boost_1_80_0/lib -L/usr/lib64/openmpi/lib

#
# Object files
#
OBJ = naranjilla.o

#
# Compile
#
naranjilla:   $(OBJ)
	$(CC) $(USER_LIBS) $(LFLAGS) -o $@ $(OBJ) $(LIBS)

naranjilla.o: 
	$(CC) $(PREPROC) $(INCLUDE) $(CFLAGS) -o $(OBJ) naranjilla.cpp

#
# Clean out object files and the executable.
#
clean:
	rm -fr *.o *.d 



