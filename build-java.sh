#!/usr/bin/env bash
version="$(cat version.txt)"

rm -f build/*.zip

for pack in "ClassiCube"*; do
	# command line zip is weird and will include the enclosing folder unless you run cd
	cd "$pack"
	zip -x "*Thumbs.db" -x "*DS_Store*" -9r "../build/$pack $version.zip" *
	cd ..
done

exit
