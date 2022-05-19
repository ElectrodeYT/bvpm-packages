# Generic ./configure script

# Check if we want to clean the build dirs first
function package_clean() {
	echo $NAME: cleaning directories
	rm -rf prefix package 2> /dev/null; true
	rm -rf $FOLDER 2> /dev/null; true
	rm -rf $FILE 2> /dev/null; true
	rm -rf ../$NAME.bvp 2> /dev/null; true
}

# Download the package if we need to
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
      ( $CONFIGURE_PRE )
    fi
    (cd $FOLDER/build; ../configure --prefix=/usr $CONFIGURE_ARGUMENTS)
  fi
  (cd $FOLDER/build; make -j$(nproc) $MAKE_ARGUMENTS)
  rm -rf prefix
  mkdir -p prefix
  (cd $FOLDER/build; make DESTDIR=$(pwd)/../../prefix $INSTALL_ARGUMENTS install -j$(nproc))
}

function pack() {
  # Check if we even have the valid source files
  # prefix should only be created after the make install, so if it doesnt exist,
  # we have not fully compiled yet
  if [ ! -d "prefix" ]; then
    echo $NAME: build not called yet!
    return
  fi
  if [ $(type -t setup_prefix) == function ]; then
    setup_prefix
  fi
  # The usr/share/info/dir file is a bit weird;
  # TL;DR: in about 99% of cases if we have it we want to yeet it
  rm -rf prefix/usr/share/info/dir 2> /dev/null; true
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
  if [ ! -z "$DEPENDENCY" ]; then
    echo DEPENDENCY=$DEPENDENCY >> package/manifest
  fi
  echo "Create .bvp file with tar"
  (cd package; tar -cf ../../$NAME.bvp *)
}