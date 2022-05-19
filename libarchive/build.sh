# Generic ./configure script
VERSION=3.6.1
DOWNLOAD=https://github.com/libarchive/libarchive/releases/download/v3.6.1/libarchive-3.6.1.tar.xz
FILE=libarchive-3.6.1.tar.xz
FOLDER=libarchive-3.6.1
NAME=libarchive
CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS=""
DEPENDENCY=glibc,zlib,libmd,bzip2,acl,attr
source configure-script.sh
function build() {
  (cd $FOLDER; ./configure --prefix=/usr --without-expat --without-xml2 --without-lz4 --without-libb2 --without-libb2 --without-openssl --without-neetle $CONFIGURE_ARGUMENTS)
  (cd $FOLDER; make -j$(nproc) $MAKE_ARGUMENTS)
  rm -rf prefix
  mkdir -p prefix
  (cd $FOLDER; make DESTDIR=$(pwd)/../prefix $INSTALL_ARGUMENTS install -j$(nproc))
}