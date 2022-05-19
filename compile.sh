PACKAGE=$1
if [ -z "$PACKAGE" ]; then
  echo "no package given"
  exit
fi

if [[ "$PACKAGE" == "clean-all" ]]; then
  echo "cleaning all packages"
  for package in */; do
    REALPACKNAME=$(echo "$package" | sed 's/\///g')
    ./$0 $REALPACKNAME clean
  done
  exit
fi

if [[ "$PACKAGE" == "download-all" ]]; then
  echo "downloading all packages"
  for package in */; do
    REALPACKNAME=$(echo "$package" | sed 's/\///g')
    ./$0 $REALPACKNAME download
  done
  exit
fi

if [[ "$PACKAGE" == "build-all" ]]; then
  echo "building all packages"
  for package in */; do
    REALPACKNAME=$(echo "$package" | sed 's/\///g')
    ./$0 $REALPACKNAME build
  done
  exit
fi

if [[ "$PACKAGE" == "pack-all" ]]; then
  echo "packing all packages"
  for package in */; do
    REALPACKNAME=$(echo "$package" | sed 's/\///g')
    ./$0 $REALPACKNAME clean
  done
  exit
fi

if [[ "$PACKAGE" == "do-all" ]]; then
  echo "fully constructing all packages"
  for package in */; do
    REALPACKNAME=$(echo "$package" | sed 's/\///g')
    ./$0 $REALPACKNAME
  done
  exit
fi



if ! [ -d "$PACKAGE" ]; then
  echo "package $PACKAGE doesnt exist!"
  exit
fi

source $PACKAGE/build.sh
cd $PACKAGE
if [[ " $@ " =~ " clean " ]]; then
  echo cleaning package $PACKAGE
  OP_DONE=1
  package_clean
  rm -rf $PACKAGE.bvp 2> /dev/null; true
fi

if [[ " $@ " =~ " download" ]]; then
  echo downloading package $PACKAGE
  OP_DONE=1
  check_and_download
fi

if [[ " $@ " =~ " build" ]]; then
  echo building package $PACKAGE
  OP_DONE=1
  check_and_download
  build
fi

if [[ " $@ " =~ " pack" ]]; then
 echo packing package $PACKAGE
 OP_DONE=1
 pack
fi

if [ -z $OP_DONE ]; then
  echo building and packing $PACKAGE
  check_and_download
  build
  pack
fi