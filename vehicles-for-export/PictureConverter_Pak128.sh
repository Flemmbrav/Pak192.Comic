#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	convert $oldimage -transparent '#000000' $oldimage
	#convert Test.png -transparent '#000000' Test.png

	#convert $oldimage -brightness-contrast -15x25 -modulate 100,80 $oldimage
	#convert $oldimage -brightness-contrast 0x5 -modulate 100,80 $oldimage
	#convert $oldimage -resize 66.6666666% $oldimage
	convert $oldimage -resize 133.3333333% $oldimage
	convert $oldimage -adaptive-resize 50% $oldimage	
	#Characteristics of: -resize 66.6666666% instead of -resize 133.3333333% -adaptive-resize 50%
	#  - looks more blurry
	#  - less risk of weird windows
	convert $oldimage -roll +0-4 $oldimage
	#0px to the right and -4 px down

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
readallfiles '../Pak128/image/*.png'
readallfiles '../Pak128/tram_image/*.png'
readallfiles '../Pak128/**/image/*.png'
readallfiles '../Pak128/**/tram_image/*.png'
echo "==== done ===="
# pause