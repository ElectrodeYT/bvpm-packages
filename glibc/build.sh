# Generic ./configure script

VERSION=2.35
DOWNLOAD=https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.xz
FILE=glibc-2.35.tar.xz
FOLDER=glibc-2.35
NAME=glibc

CONFIGURE_PRE=(cp ../../configparms .)
CONFIGURE_ARGUMENTS="--enable-kernel=3.2 libc_cv_slibdir=/usr/lib"

# Check if we want to clean the build dirs first
function package_clean() {
	echo $NAME: cleaning directories
	rm -rf prefix 2> /dev/null; true
	rm -rf $FOLDER 2> /dev/null; true
	rm -rf $FILE 2> /dev/null; true
}

# Download glibc if we need to
function download() {
  rm -rf $FILE 2> /dev/null; true
  wget $DOWNLOAD
  tar xf $FILE
}

function check_and_download() {
    if [ ! -d "$FOLDER" ]; then
      download
    fi
}

function build() {
  if [ ! -d "$FOLDER/build" ]; then
    rm -rf prefix 2> /dev/null; true
    mkdir -p $FOLDER/build
    if [ ! -z "$CONFIGURE_PRE" ]; then
        (cd $FOLDER/build; ${CONFIGURE_PRE[@]})
    fi
    (cd $FOLDER/build; ../configure --prefix=/usr $CONFIGURE_ARGUMENTS)
  fi
  (cd $FOLDER/build; make -j$(nproc))
  rm -rf prefix
  mkdir -p prefix
  (cd $FOLDER/build; make DESTDIR=$(pwd)/../../prefix install -j$(nproc))
}

function pack() {
  # Check if we even have the valid source files
  # prefix should only be created after the make install, so if it doesnt exist,
  # we have not fully compiled yet
  if [ ! -d "prefix" ]; then
    echo $NAME: build not called yet!
    return
  fi
  echo "Generating owned-files"
  rm -rf package 2> /dev/null; true
  mkdir -p package
  rm -rf package/owned-files 2> /dev/null; true
  (cd prefix; find -type f | cut -c 2- > ../package/owned-files)
  echo "Copy prefix files"
  mkdir -p package/root
  cp -r prefix/* package/root/
  echo "Generate manifest"
  rm -rf package/manifest 2> /dev/null; true
  echo PACKAGE=$NAME > package/manifest
  echo VERSION=$VERSION >> package/manifest
  echo "Create .bvp file with tar"
  (cd package; tar -cf ../../$NAME.bvp *)
}