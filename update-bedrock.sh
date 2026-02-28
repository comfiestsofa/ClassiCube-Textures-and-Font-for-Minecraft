#!/usr/bin/env bash

# delete all folders inside each bedrock pack
rm -rf "bedrock/"*"/"*"/"

for pack in ClassiCube*/; do
	packname="$(basename "$pack")"

	# copy pack.png to pack_icon.png
	cp -a "$pack/pack.png" "bedrock/$packname/pack_icon.png"

	cp -a "$pack/_CREDITS.txt" "bedrock/$packname/"

	# copy content folders
	cp -a "$pack/assets/minecraft/"* "bedrock/$packname/"

	# bedrock renamed block to blocks
	mv "bedrock/$packname/textures/block" "bedrock/$packname/textures/blocks"

	# bedrock doesn't support changing vanilla block models
	rm -rf "bedrock/$packname/models"
done

exit
