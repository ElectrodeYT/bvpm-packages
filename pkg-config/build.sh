# Generic ./configure script

VERSION=0.29.2
DOWNLOAD=https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
FILE=pkg-config-0.29.2.tar.gz
FOLDER=pkg-config-0.29.2
NAME=pkg-config

CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS="--with-internal-glib --disable-host-tool --docdir=/usr/share/doc/pkg-config-0.29.2"

source configure-script.sh