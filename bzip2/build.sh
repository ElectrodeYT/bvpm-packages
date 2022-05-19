VERSION=1.0.8
DOWNLOAD=https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
FILE=bzip2-1.0.8.tar.gz
FOLDER=bzip2-1.0.8
NAME=bzip2


# Check if we want to clean the build dirs first
function package_clean() {
	echo $NAME: cleaning directories
	rm -rf prefix package .fixed-stuff 2> /dev/null; true
	rm -rf $FOLDER 2> /dev/null; true
	rm -rf $FILE 2> /dev/null; true
	rm -rf ../$NAME.bvp 2> /dev/null; true
}

# Download bzip2 if we need to
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

function build() {
    if [ ! -f ".fixed-stuff" ]; then
      rm -rf prefix 2> /dev/null; true
      (cd $FOLDER; sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile)
      (cd $FOLDER; sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile)
      echo doing weird bz2 stuff
      (cd $FOLDER; make -f Makefile-libbz2_so)
      (cd $FOLDER; make clean)
      touch ".fixed-stuff"
    fi
    (cd $FOLDER; make -j$(nproc))
    rm -rf prefix
    mkdir -p prefix
    (cd $FOLDER; make PREFIX=$(pwd)/../prefix/usr install -j$(nproc))
    (cd $FOLDER; cp -av libbz2.so.* $(pwd)/../prefix/usr/lib)
    (cd $FOLDER; ln -sv libbz2.so.1.0.8 $(pwd)/../prefix/usr/lib/libbz2.so)
}