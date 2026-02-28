#!/usr/bin/env bash
rm -rf build
mkdir build

for pack in "ClassiCube"*; do
	# command line zip is weird and will include the enclosing folder unless you run cd
	cd "$pack"
	zip -x "*Thumbs.db" -x "*DS_Store*" -9r "../build/$pack.zip" *
	cd ..
done

cd bedrock
for pack in "ClassiCube"*; do
	cd "$pack"
	zip -x "*Thumbs.db" -x "*DS_Store*" -9r "../../build/$pack.mcpack" *
	cd ..
done

exit
