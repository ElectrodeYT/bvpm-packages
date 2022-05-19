#!/bin/bash
echo "fix lib for gcc"
cd ..
source gcc/build.sh
cd gcc/$FOLDER
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
