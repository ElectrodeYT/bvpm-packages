if [[ " $@ " =~ " clean " ]]; then
	(cd glibc; ./build-glibc.sh clean)
else
	(cd glibc; ./build-glibc.sh)
fi

