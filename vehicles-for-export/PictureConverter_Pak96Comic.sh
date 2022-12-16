#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	
	#convert $oldimage -transparent '#000000' $oldimage
	convert $oldimage -interpolative-resize 50%% $oldimage
	#convert $oldimage -interpolative-resize 66.6666666%% $oldimage
	#convert $oldimage -liquid-rescale 75%% $oldimage
	#convert $oldimage -interpolative-resize 66.6666666%% $oldimage
	convert $oldimage -brightness-contrast 0x25 $oldimage
	#convert $oldimage -roll +0-2 $oldimage
	#0px to the right and -2 px down
	convert $oldimage -channel A -threshold 254 $oldimage

}

readallfiles() {
	local directionary=$1
	IFS='
	'
	if [ ${#directionary[@]} -gt 0 ] ; then

	  	for png in $directionary ; do

	  		if [ -f "$png" ] ; then
				echo "-- Performing Work At: $png "
				convertpng $png
			fi
		done
	fi
}

#`rm -rf converted_image/`
#mkdir -p converted_image/image
#`cp -rf image/* converted_image/image`

`cp -rf ../ToBeExported/image* ../Pak96Comic/`
`cp -rf ../ToBeExported/tram_image* ../Pak96Comic/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak96Comic/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak96Comic/AddOn/`

echo "==== Picture Converter ===="
readallfiles '../Pak96Comic/image/*.png'
readallfiles '../Pak96Comic/tram_image/*.png'
readallfiles '../Pak96Comic/**/image/*.png'
readallfiles '../Pak96Comic/**/tram_image/*.png'
echo "==== done ===="
# pause