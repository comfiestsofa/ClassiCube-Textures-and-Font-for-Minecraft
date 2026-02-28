#!/usr/bin/env bash
version="1.0"

for pack in "ClassiCube"*; do
	# command line zip is weird and will include the enclosing folder unless you run cd
	cd "$pack"
	zip -x "*Thumbs.db" -x "*DS_Store*" -9r "../build/$pack $version.zip" *
	cd ..
done

cd bedrock
for pack in "ClassiCube"*; do
	cd "$pack"
	zip -x "*Thumbs.db" -x "*DS_Store*" -9r "../../build/$pack $version.mcpack" *
	cd ..
done

exit
