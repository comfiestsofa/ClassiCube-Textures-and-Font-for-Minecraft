#!/usr/bin/env bash
rm -rf "bedrock/"*"/"*"/" # delete all folders inside each bedrock pack
for pack in ClassiCube*/; do
	packname="$(basename "$pack")"
	cp -a "$pack/pack.png" "bedrock/$packname/pack_icon.png"
	cp -a "$pack/assets/minecraft/"* "bedrock/$packname/"
	mv "bedrock/$packname/textures/block" "bedrock/$packname/textures/blocks"
done

exit
