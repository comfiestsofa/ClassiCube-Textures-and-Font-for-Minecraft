#!/usr/bin/env bash

# delete all folders inside each bedrock pack
rm -rf bedrock/*/*/

# delete builds
rm -f build/*.zip
rm -f build/*.mcpack

# build java zips
./build-java.sh

path="$PWD"

# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
if [[ "$OSTYPE" == "cygwin" ]]; then
	# POSIX compatibility layer and Linux environment emulation for Windows
	path="$(cygpath -m "$PWD")"
elif [[ "$OSTYPE" == "msys" ]]; then
	# Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
	path="$(cygpath -m "$PWD")"
elif [[ "$OSTYPE" == "win32" ]]; then
	# I'm not sure this can happen.
	path="$(cygpath -m "$PWD")"
fi

temp=$(mktemp -d -p .)

for pack in build/*.zip; do
	PackConverter/gradlew -p PackConverter run --args="nogui debug --input \"$path/$pack\""

	# https://stackoverflow.com/questions/12152626/how-can-i-remove-the-extension-of-a-filename-in-a-shell-script
	mv "${pack%.*}.mcpack" "$temp/"
done

cd bedrock
for pack in ClassiCube*/; do
	packname="$(basename "$pack")"
	cp -a "$pack/pack.png" "bedrock/$packname/pack_icon.png"
	cp -a "$pack/_CREDITS.txt" "bedrock/$packname/"
done

rm -rf "$temp"

exit
