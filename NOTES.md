
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
