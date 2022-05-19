# Generic ./configure script

VERSION=4.1.0
DOWNLOAD=https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz
FILE=mpfr-4.1.0.tar.xz
FOLDER=mpfr-4.1.0
NAME=mpfr

CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS="--enable-thread-safe --docdir=/usr/share/doc/mpfr-4.1.0"

source configure-script.sh