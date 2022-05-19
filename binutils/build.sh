VERSION=2.38
DOWNLOAD=https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz
FILE=binutils-2.38.tar.xz
FOLDER=binutils-2.38
NAME=binutils
CONFIGURE_ARGUMENTS="--enable-gold --enable-ld=default --enable-plugins --enable-shared --disable-werror --enable-64-bit-bfd --with-system-zlib"
MAKE_ARGUMENTS="tooldir=/usr"
INSTALL_ARGUMENTS="tooldir=/usr"
source configure-script.sh
DEPENDENCY=glibc