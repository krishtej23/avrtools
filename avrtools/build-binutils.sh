#!/bin/sh

. ./config.sh

bootstrap binutils

echod "Building binutils ${BINUTILS_VERSION}"

cd build/binutils-${BINUTILS_VERSION} || \
	die "Could not CD to build/binutils-${BINUTILS_VERSION}"

mkdir obj-avr
cd obj-avr

test -f config.status || {
	../configure --target=avr --disable-werror --prefix=$PREFIX --with-mpc=$LIBPREFIX --with-mpfr=$LIBPREFIX --with-gmp=$LIBPREFIX --disable-gdb --enable-lto >$LOGS/binutils-config.log 2>&1 || \
		die "Could not configure BINUTILS ${BINUTILS_VERSION}"
}

make configure-host >$LOGS/binutils-configure-host.log 2>&1 || \
	die "Could not make configure-host for BINUTILS ${BINUTILS_VERSION}"

cd bfd
$MAKE headers >$LOGS/binutils-headers.log 2>&1 || \
	die "Could not build bfd headers for BINUTILS ${BINUTILS_VERSION}"
cd ..


$MAKE >$LOGS/binutils-make.log 2>&1 || \
	die "Could not build BINUTILS ${BINUTILS_VERSION}"

#$MAKE  check || \
#	die "BINUTILS ${BINUTILS_VERSION} tests failed"

$MAKE install >$LOGS/binutils-install.log 2>&1 || \
	die "Could not install ${BINUTILS_VERSION}"

# The libtools stubs get copied on Windows, rather that the executables
# Workaround it for now
if test `uname` = 'MINGW32_NT-6.1'; then
	for file in `find . -name '*.exe' | grep '.libs'`; do
		newname="`basename $file`"
		newname="avr-`echo $newname | sed s/-new//`"
		cp $file $PREFIX/bin/$newname
	done
fi
	
cd ..
for file in COPYING*; do
	cp $file $PREFIX/licenses/$file.binutils
done

echod "Done building binutils ${BINUTILS_VERSION}"
