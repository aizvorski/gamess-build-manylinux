# gamess-build-multilinux

Build GAMESS on multilinux docker images

## How to build

Make sure you have docker installed on the host machine.

Download the GAMESS source to inside this repo, for example with:
```
wget https://www.msg.chem.iastate.edu/GAMESS/download/source/gamess-current.tar.gz
```

Run docker container and do the build inside it:
```
docker run -t -i --rm  -v `pwd`:/shared quay.io/pypa/manylinux2014_x86_64 bash /shared/build.sh
```

After a while (20-30 minutes), this command finishes and a compiled GAMESS binary is in gamess/gamess.00.x

## How the built GAMESS is configured

GAMESS has many configuration options; in the interest of portability, this process makes some significant assumptions.

The biggest assumption is that the compiled binary would be run on a single machine / node.  GAMESS normally has a variety of methods to run on multiple nodes (MPI, sockets etc) but none of these are included here.
However OpenMP is included, so this version would run efficiently on a single machine with potentially very large number of cores (64 or more).

There are also many options for a math library (BLAS).  This version is compiled with OpenBLAS 0.3.3.

## OS compatibility

The resulting binary is intended to be widely portable across recent Linux versions.  
