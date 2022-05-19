VERSION=2.35
DOWNLOAD=https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.xz
FILE=glibc-2.35.tar.xz
FOLDER=glibc-2.35
NAME=glibc
CONFIGURE_PRE=(cp ../../configparms .)
CONFIGURE_ARGUMENTS="--enable-kernel=3.2 libc_cv_slibdir=/usr/lib"
source configure-script.sh

function setup_prefix() {
    mkdir -p prefix/etc
    cp nsswitch.conf prefix/etc
}