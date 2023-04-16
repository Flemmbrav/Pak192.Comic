#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	convert $oldimage -transparent '#000000' $oldimage
	#convert Test.png -transparent '#000000' Test.png


	### Tests
	#convert $oldimage -brightness-contrast -15x25 -modulate 100,80 $oldimage
	#convert $oldimage -brightness-contrast 0x5 -modulate 100,80 $oldimage
	#convert $oldimage -brightness-contrast 0x5 $oldimage
	#convert $oldimage -resize 66.6666666% $oldimage


	### Converting to pak128 size
	# convert $oldimage -resize 133.3333333% $oldimage
	# convert $oldimage -adaptive-resize 50% $oldimage	
	#Characteristics of: -resize 66.6666666% instead of -resize 133.3333333% -adaptive-resize 50%
	#  - looks more blurry
	#  - less risk of weird windows

	### Converting to pak28.Japan size old
	#convert $oldimage -interpolative-resize 150% -interpolative-resize 50% $oldimage
	convert $oldimage -magnify -interpolative-resize 75% $oldimage
	convert $oldimage -channel A -threshold 25% $oldimage
	convert $oldimage -interpolative-resize 50% $oldimage
	convert $oldimage -channel A -threshold 25% $oldimage
	# 2*18/24
	# 18 representing 144px, 24 representing 192px, the 2 being the 50% at the end

	convert $oldimage -roll -8-10 $oldimage
	#8px to the right and 11px down

	### Converting to pak28.Japan size new
	#convert $oldimage -interpolative-resize 166.6666666% -interpolative-resize 50% $oldimage
	#convert $oldimage -magnify -interpolative-resize 83.33333333% $oldimage
	#convert $oldimage -channel A -threshold 25% $oldimage
	#convert $oldimage -interpolative-resize 50% $oldimage
	#convert $oldimage -channel A -threshold 25% $oldimage
	# 2*20/24
	# 20 representing 160px, 24 representing 192px, the 2 being the 50% at the end

	#convert $oldimage -roll -16-24 $oldimage
	#8px to the right and 13px down

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
readallfiles '../Pak128Japan/image/*.png'
readallfiles '../Pak128Japan/tram_image/*.png'
readallfiles '../Pak128Japan/**/image/*.png'
readallfiles '../Pak128Japan/**/tram_image/*.png'
echo "==== done ===="
# pause