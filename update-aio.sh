#!/usr/bin/env bash
rm -rf "ClassiCube All-In-One/assets"
for pack in \
	"ClassiCube Font" \
	"ClassiCube Blocks, FX" \
	"ClassiCube Mobs (MC)" \
	"ClassiCube UI"; do
		cp -a "$pack/assets" "ClassiCube All-In-One/"
done

exit
