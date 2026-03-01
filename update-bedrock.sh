#!/usr/bin/env bash
version="$(cat version.txt)"

# delete all folders inside each bedrock pack
rm -rf bedrock/*/*/

# delete builds
rm -f build/*.zip
rm -f build/*.mcpack

# build java zips
./build-java.sh

path="$PWD"

# idk why but gradlew run doesn't like the /e/ style paths so the solution is apparently to use cygpath -m (shrug)
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
winpath="$PWD"
if [[ "$OSTYPE" == "cygwin" ]]; then
	# POSIX compatibility layer and Linux environment emulation for Windows
	winpath="$(cygpath -m "$PWD")"
elif [[ "$OSTYPE" == "msys" ]]; then
	# Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
	winpath="$(cygpath -m "$PWD")"
elif [[ "$OSTYPE" == "win32" ]]; then
	# I'm not sure this can happen.
	winpath="$(cygpath -m "$PWD")"
fi

temp=$(mktemp -d -p $PWD)

for pack in build/*.zip; do
	PackConverter/gradlew -p PackConverter run --args="nogui debug --input \"$winpath/$pack\""

	# https://stackoverflow.com/questions/12152626/how-can-i-remove-the-extension-of-a-filename-in-a-shell-script
	mv "${pack%.*}.mcpack" "$temp/"
done

cd bedrock
for pack in ClassiCube*/; do
	# double slash causes problems
	# https://stackoverflow.com/questions/9018723/what-is-the-simplest-way-to-remove-a-trailing-slash-from-each-parameter
	pack=${pack%/}
	packname="$(basename "$pack")"
	cp -a "$path/$pack/pack.png" "$packname/pack_icon.png"
	# prevent errors
	if [ -f "$path/$pack/_CREDITS.txt" ]; then cp -a "$path/$pack/_CREDITS.txt" "$packname/"; fi

	# unzip contents
	unzip -n "$temp/$packname $version".mcpack -d "$packname"

	# replace generated coloured water with classicube coloured water
	if [ -f "$packname/textures/blocks/water_still.png" ]; then
		cp -a "$packname/textures/blocks/unused-classicube/water_still_coloured.png" "$packname/textures/blocks/water_still.png"
	fi
	if [ -f "$packname/textures/blocks/water_flow.png" ]; then
		cp -a "$packname/textures/blocks/unused-classicube/water_flow_coloured.png" "$packname/textures/blocks/water_flow.png"
	fi

	# fix packconverter bug putting creeper and skeleton textures in the wrong places
	if [ -f "$packname/textures/entity/creeper.png" ]; then
		mv -f "$packname/textures/entity/creeper.png" "$packname/textures/entity/creeper/"
	fi
	if [ -f "$packname/textures/entity/skeleton.png" ]; then
		mv -f "$packname/textures/entity/skeleton.png" "$packname/textures/entity/skeleton/"
	fi

	# fix packconverter not duplicating the chicken texture (idk why bedrock has a second copy of this?)
	if [ -f "$packname/textures/entity/chicken/chicken.png" ]; then
		cp -a "$packname/textures/entity/chicken/chicken.png" "$packname/textures/entity/"
	fi

	# fix packconverter not duplicating creeper and skeleton textures into the skulls folder
	if [ -f "$packname/textures/entity/creeper/creeper.png" ]; then
		cp -a "$packname/textures/entity/creeper/creeper.png" "$packname/textures/entity/skulls/"
	fi
	if [ -f "$packname/textures/entity/skeleton/skeleton.png" ]; then
		cp -a "$packname/textures/entity/skeleton/skeleton.png" "$packname/textures/entity/skulls/"
	fi

	# fix packconverter not processing grass_side.tga correctly
	if [ -f "$packname/textures/blocks/grass_side.tga" ]; then
		magick "$packname/textures/blocks/grass_side_carried.png" -alpha set -channel A -evaluate set 1 +channel "$packname/textures/blocks/grass_side.tga" -compose over -composite "$packname/textures/blocks/grass_side.tga"
	fi
done

rm -rf "$temp"
# delete java builds
rm -f "$path/build/"*.zip

exit
