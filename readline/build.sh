VERSION=8.1.2
DOWNLOAD=https://ftp.gnu.org/gnu/readline/readline-8.1.2.tar.gz
FILE=readline-8.1.2.tar.gz
FOLDER=readline-8.1.2
NAME=readline

CONFIGURE_ARGUMENTS="--with-cursers --docdir=/usr/share/doc/readline-8.1.2"
MAKE_ARGUMENTS="SHLIB_LIBS=\"-lncursesw\""
INSTALL_ARGUMENTS=$MAKE_PARAMS

source configure-script.sh