VERSION=1.5.2
DOWNLOAD=https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz
FILE=zstd-1.5.2.tar.gz
FOLDER=zstd-1.5.2
NAME=zstd
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
    (cd $FOLDER; make -j$(nproc) prefix=$(pwd)/../prefix/usr)
    rm -rf prefix
    mkdir -p prefix
    (cd $FOLDER; make prefix=$(pwd)/../prefix/usr install -j$(nproc))
}
DEPENDENCY=glibc