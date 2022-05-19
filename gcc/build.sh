# Generic ./configure script

VERSION=12.1.0
DOWNLOAD=https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz
FILE=gcc-12.1.0.tar.xz
FOLDER=gcc-12.1.0
NAME=gcc

CONFIGURE_PRE="./fix-lib.sh"
CONFIGURE_ARGUMENTS="LD=ld --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib"

source configure-script.sh