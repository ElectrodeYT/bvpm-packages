# Generic ./configure script

VERSION=3.6.1
DOWNLOAD=https://github.com/libarchive/libarchive/releases/download/v3.6.1/libarchive-3.6.1.tar.xz
FILE=libarchive-3.6.1.tar.xz
FOLDER=libarchive-3.6.1
NAME=libarchive

CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS=""

source configure-script.sh

function build() {
  (cd $FOLDER; ./configure --prefix=/usr $CONFIGURE_ARGUMENTS)
  (cd $FOLDER; make -j$(nproc) $MAKE_ARGUMENTS)
  rm -rf prefix
  mkdir -p prefix
  (cd $FOLDER; make DESTDIR=$(pwd)/../prefix $INSTALL_ARGUMENTS install -j$(nproc))
}