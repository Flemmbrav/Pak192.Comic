#!/bin/bash

#set -e

convertpng() {

	local oldimage=$1
	#echo $oldimage
	convert $oldimage -transparent '#e7ffff' -transparent '#000000' -transparent '#001eff' $oldimage
	#convert Test.png -transparent '#000000' Test.png

	#Converting first player colour to red
	convert $oldimage -fill '#771111' -opaque '#244B67' -fill '#881111' -opaque '#395E7C' -fill '#991111' -opaque '#4c7191' -fill '#AA1111' -opaque '#6084a7' -fill '#BB1111' -opaque '#7497bd' -fill '#CC1111' -opaque '#88abd3' -fill '#DD1111' -opaque '#9cbee9' -fill '#EE1111' -opaque '#B0D2FF' $oldimage
	# magick Test.png -fill #771111 -opaque #244B67 Test.png 
	# magick Test.png -fill #881111 -opaque #395E7C Test.png 
	# magick Test.png -fill #991111 -opaque #4c7191 Test.png 
	# magick Test.png -fill #AA1111 -opaque #6084a7 Test.png 
	# magick Test.png -fill #BB1111 -opaque #7497bd Test.png 
	# magick Test.png -fill #CC1111 -opaque #88abd3 Test.png 
	# magick Test.png -fill #DD1111 -opaque #9cbee9 Test.png 
	# magick Test.png -fill #EE1111 -opaque #B0D2FF Test.png 

	#Converting second player colour to blue
	convert $oldimage -fill '#111177' -opaque '#7B5803' -fill '#111188' -opaque '#8E6F04' -fill '#111199' -opaque '#A18605' -fill '#1111AA' -opaque '#B49D07' -fill '#1111BB' -opaque '#C6B408' -fill '#1111CC' -opaque '#D9CB0A' -fill '#1111DD' -opaque '#ECE20B' -fill '#1111EE' -opaque '#FFF90D' $oldimage

	convert $oldimage -interpolative-resize 50%% $oldimage
	convert $oldimage -adaptive-resize 66.6666666%% $oldimage
	convert $oldimage -brightness-contrast 0x15 $oldimage
	convert $oldimage -roll +0-1 $oldimage
	#0px to the right and -1 px down

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
readallfiles '../Pak128Britain/image/*.png'
readallfiles '../Pak128Britain/tram_image/*.png'
readallfiles '../Pak128Britain/**/image/*.png'
readallfiles '../Pak128Britain/**/tram_image/*.png'
echo "==== done ===="
# pause