# Generic ./configure script

VERSION=6.2.1
DOWNLOAD=https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz
FILE=gmp-6.2.1.tar.xz
FOLDER=gmp-6.2.1
NAME=gmp

CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS="--enable-cxx --docdir=/usr/share/doc/gmp-6.2.1"

source configure-script.sh