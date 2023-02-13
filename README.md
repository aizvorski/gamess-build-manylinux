# gamess-build-manylinux

Build portable [GAMESS](https://www.msg.chem.iastate.edu/gamess/index.html) in a [manylinux](https://github.com/pypa/manylinux) docker image

## How to build

Make sure you have docker installed on the host machine (typically `sudo apt install docker.io` or `sudo yum install docker`).

Download the GAMESS (version 2022.2) source tar.gz to inside this repo, for example with:
```
wget https://www.msg.chem.iastate.edu/GAMESS/download/source/gamess-current.tar.gz
```

Run docker container and do the build inside it:
```
docker run -t -i --rm  -v `pwd`:/shared quay.io/pypa/manylinux2014_x86_64 bash /shared/build.sh
```

After a while (20-30 minutes), this command finishes and a compiled GAMESS binary is in gamess/gamess.00.x

## How GAMESS is configured

GAMESS has many configuration options; in the interest of portability, the build method here makes some significant assumptions.

The biggest assumption is that the compiled binary would be run on a single machine only.  GAMESS normally has a variety of methods to run on multiple nodes (MPI, sockets etc) but none of these are included here.  However OpenMP is included, so this version would run efficiently on a single machine with potentially very large number of cores (64 or more).

There are also many options for a math library (BLAS).  This version is compiled with OpenBLAS 0.3.3.

## OS compatibility

The resulting binary is intended to be widely portable across recent Linux versions.  It uses the [manylinux](https://github.com/pypa/manylinux) method of dynamically linking old versions of libc, libm and libpthread (which newer versions are backward compatible with using symbol versioning) and statically linking everything else.

Currently it uses manylinux2014, compatible with Ubuntu 20.04+, CentOS 7+, Fedora 32+, and openSUSE 15.3+ (and probably all the way back to RHEL 7+ and Ubuntu 13.04+).  It is not necessary to install any dependencies in the distro to run the resulting binary.  The build itself is hosted on CentOS 7 and uses the GCC 10 toolchain.

## Todo

- [ ] Run tests after build
- [ ] Set owner/permissions on resulting binary
- [ ] Package binary+extra files as a tar.gz
- [ ] Statically link libgomp as well
- [ ] Link using a patched version of lked (need to figure out how to make lked use gcc as the linker, and pass a bunch of extra options at the end)
- [ ] Build with Intel MKL (possibly faster, need to check license)
- [ ] Include LibXC

## Disclaimer

This is not an official part of GAMESS, just a separate set of build scripts.  The resulting binary has not been tested much or at all; the compilation succeeds and that's about it (for now).
