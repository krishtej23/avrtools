#!/bin/sh

. ./config.sh

echod "Building MPC ${MPC_VERSION}"

cd build/mpc-${MPC_VERSION} || \
	die "Could not CD to build/mpc-${MPC_VERSION}"

test -f config.log || {
	./configure --prefix=$LIBPREFIX --enable-static --disable-shared \
	--with-mpfr-include=$LIBPREFIX/include \
	--with-gmp-include=$LIBPREFIX/include >$LOGS/mpc-config-native.log 2>&1 || \
		die "Could not configure MPC ${MPC_VERSION}"
}

$MAKE $MAKEFLAGS >$LOGS/mpc-make-native.log 2>&1 || \
	die "Could not build MPC ${MPC_VERSION}"


#$MAKE check || \
#	die "MPC ${MPC_VERSION} tests failed"

$MAKE install >$LOGS/mpc-install-native.log 2>&1 || \
	die "Could not install ${MPC_VERSION}"

$MAKE distclean >$LOGS/mpc-distclean-native.log 2>&1

cd ../gmp-${GMP_VERSION}

$MAKE distclean >$LOGS/gmp-distclean-native.log 2>&1

echod "Done building MPC ${MPC_VERSION}"
