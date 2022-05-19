# Generic ./configure script
VERSION=2.3.1
DOWNLOAD=https://download.savannah.gnu.org/releases/acl/acl-2.3.1.tar.xz
FILE=acl-2.3.1.tar.xz
FOLDER=acl-2.3.1
NAME=acl
CONFIGURE_PRE=""
CONFIGURE_ARGUMENTS="--docdir=/usr/share/doc/acl-2.3.1"
source configure-script.sh
DEPENDENCY=glibc