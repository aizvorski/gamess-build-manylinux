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

GAMESS has many configuration options; in the interest of portability, the build method here sets all of them to values that make some significant assumptions.

The biggest assumption is that the compiled binary would be run on a single machine only.  GAMESS normally has a variety of methods to run on multiple nodes (MPI, sockets etc) but none of these are included here.  However OpenMP is included, so this version would run efficiently on a single machine with potentially very large number of cores (64 or more).

There are also many options for a math library (BLAS).  This version is compiled with OpenBLAS 0.3.3.

## OS compatibility

The resulting binary is intended to be widely portable across recent Linux versions.  It uses the [manylinux](https://github.com/pypa/manylinux) method of dynamically linking old versions of libc, libm and libpthread (which newer versions are backward compatible with using symbol versioning) and statically linking everything else.

Currently it uses manylinux2014, compatible with Ubuntu 20.04+, CentOS 7+, Fedora 32+, and openSUSE 15.3+ (and probably all the way back to RHEL 7+ and Ubuntu 13.04+).  It is not necessary to install any dependencies in the distro to run the resulting binary.  The build itself is hosted on CentOS 7 and uses the GCC 10 toolchain.

## Technical notes

It seems the only way to link libquadmath statically is to do the linking with gcc (instead of gfortran) because of https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46539

The magic set of options which only links the necessary libraries dynamically and everything else statically is `-static-libgcc -Wl,-Bstatic -lgfortran -lquadmath -Wl,-Bdynamic -lm -pthread`.  This should be at the end of the linker commandline.  I couldn't figure out how to patch the builtin lked to do this, so for now the linker is just called directly from build.sh (which would need updating for every new version).

There may be a way to link libgomp statically, but I haven't figured one out yet.

On Ubuntu 20.04 for example, ldd shows these (fairly minimal) dependencies

```
$ ldd gamess/gamess.00.x 
	linux-vdso.so.1 (0x00007ffe11bc6000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9c09c46000)
	libgomp.so.1 => /lib/x86_64-linux-gnu/libgomp.so.1 (0x00007f9c09c04000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f9c09be1000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9c099ef000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f9c09db3000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f9c099e9000)
```

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
