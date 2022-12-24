#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	
	convert $oldimage -transparent '#000000' $oldimage
	#convert $oldimage -brightness-contrast 0x25 $oldimage
	#convert $oldimage -interpolative-resize 50%% $oldimage
	#convert $oldimage -adaptive-resize 66.6666666%% $oldimage
	convert $oldimage -roll +0+2 $oldimage
	#0px to the right and 2 px down => equals 0,5px down after the scaling
	convert $oldimage -resize 133.3333333% $oldimage
	#convert $oldimage -adaptive-resize 25%% $oldimage
	convert $oldimage -adaptive-resize 50%% $oldimage
	convert $oldimage -adaptive-resize 50%% $oldimage
	convert $oldimage -brightness-contrast 0x25 $oldimage
	#convert $oldimage -roll +0-2 $oldimage
	#0px to the right and -2 px down

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

echo "==== Picture Converter ===="
#readallfiles '../Pak64German/image/*.png'
readallfiles '../Pak64German/tram_image/*.png'
#readallfiles '../Pak64German/**/image/*.png'
#readallfiles '../Pak64German/**/tram_image/*.png'
echo "==== done ===="
# pause