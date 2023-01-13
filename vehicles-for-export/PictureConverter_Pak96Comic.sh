#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	
	#convert $oldimage -transparent '#000000' $oldimage
	#convert $oldimage -interpolative-resize 50%% $oldimage
	#convert $oldimage -interpolative-resize 37.777777% $oldimage
	#convert $oldimage -interpolative-resize 42.222222% $oldimage
	#convert $oldimage -interpolative-resize 50%% $oldimage
	#convert $oldimage -interpolative-resize 66.6666666%% $oldimage
	#convert $oldimage -liquid-rescale 75%% $oldimage
	#convert $oldimage -interpolative-resize 66.6666666%% $oldimage
	#convert $oldimage -interpolative-resize 58.3333333% $oldimage

	#convert $oldimage -magnify -resize 116.666666% -interpolative-resize 50% -interpolative-resize 50% $oldimage
	
	#convert $oldimage -resize 116.666666% -interpolative-resize 50% $oldimage
	#convert $oldimage -interpolative-resize 116.666666% -interpolative-resize 50% $oldimage
	#convert $oldimage -magnify $oldimage
	#convert $oldimage -resize 116.666666% $oldimage
	#convert $oldimage -interpolative-resize 50% -interpolative-resize 50% $oldimage
	#convert $oldimage -interpolative-resize 116.666666% -adaptive-sharpen 2 $oldimage
	convert $oldimage -interpolative-resize 116.666666% -interpolative-resize 50% $oldimage


	#convert $oldimage -brightness-contrast 0x30 $oldimage
	convert $oldimage -brightness-contrast 5x25 -roll -8-12 -channel A -threshold 15% $oldimage
	#-8px to the right and -12 px down
	#convert $oldimage -channel A -threshold 254 $oldimage

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