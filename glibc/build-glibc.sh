GLIBC_VERSION=2.35
GLIBC_DOWNLOAD=https://ftp.gnu.org/gnu/glibc/glibc-2.35.tar.xz
GLIBC_FILE=glibc-2.35.tar.xz

mkdir -p prefix package

# Check if we want to clean the build dirs first
if [[ " $@ " =~ " clean " ]]; then
	echo cleaning directories
	rm -rf glibc-2.35/build  2> /dev/null; true
        rm -rf prefix 2> /dev/null; true
	echo removing glibc download
	rm -rf glibc-2.35 2> /dev/null; true
	rm -rf $GLIBC_FILE 2> /dev/null; true
fi

# Download glibc if we need to
if [ ! -d "glibc-2.35/build" ]; then
	rm -rf $GLIBC_FILE 2> /dev/null; true
	wget $GLIBC_DOWNLOAD
	tar xf $GLIBC_FILE
fi

if [ ! -d "glibc-2.35/build" ]; then
	rm -rf prefix 2> /dev/null; true
	mkdir -p glibc-2.35/build prefix
	(cd glibc-2.35/build; echo "rootsbindir=/usr/sbin" > configparms)
	(cd glibc-2.35/build; ../configure --prefix=/usr --enable-kernel=3.2 libc_cv_slibdir=/lib)
	(cd glibc-2.35/build; make -j$(nproc))
	(cd glibc-2.35/build; make DESTDIR=$(pwd)/../../prefix install -j$(nproc))
fi
echo "Generating owned-files"
mkdir -p package
rm -rf package/owned-files 2> /dev/null; true
(cd prefix; find -type f | cut -c 2- > ../package/owned-files)
echo "Copy prefix files"
mkdir -p package/root
cp -r prefix/* package/root/
echo "Generate manifest"
rm -rf package/manifest 2> /dev/null; true
echo "PACKAGE=glibc" > package/manifest
echo VERSION=$GLIBC_VERSION >> package/manifest
echo "Create .bvp file with tar"
(cd package; tar -cf ../glibc.bvp *)
