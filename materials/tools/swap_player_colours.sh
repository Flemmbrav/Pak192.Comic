#!/bin/bash

#set -e

convertpng() {

	oldimage=$1
	convert $oldimage -fill '#FF00F7' -opaque '#244B67' -fill '#FF00F6' -opaque '#395E7C' -fill '#FF00F5' -opaque '#4c7191' -fill '#FF00F4' -opaque '#6084a7' -fill '#FF00F3' -opaque '#7497bd' -fill '#FF00F2' -opaque '#88abd3' -fill '#FF00F1' -opaque '#9cbee9' -fill '#FF00F0' -opaque '#B0D2FF' -fill '#244B67' -opaque '#7B5803' -fill '#395E7C' -opaque '#8E6F04' -fill '#4c7191' -opaque '#A18605' -fill '#6084a7' -opaque '#B49D07' -fill '#7497bd' -opaque '#C6B408' -fill '#88abd3' -opaque '#D9CB0A' -fill '#9cbee9' -opaque '#ECE20B' -fill '#B0D2FF' -opaque '#FFF90D' -fill '#7B5803' -opaque '#FF00F7' -fill '#8E6F04' -opaque '#FF00F6' -fill '#A18605' -opaque '#FF00F5' -fill '#B49D07' -opaque '#FF00F4' -fill '#C6B408' -opaque '#FF00F3' -fill '#D9CB0A' -opaque '#FF00F2' -fill '#ECE20B' -opaque '#FF00F1' -fill '#FFF90D' -opaque '#FF00F0' $oldimage

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


echo "==== swapping player colours ===="
readallfiles '*.png'
#readallfiles '../Pak128/image/*.png'
#readallfiles '../Pak128/tram_image/*.png'
#readallfiles '../Pak128/**/image/*.png'
#readallfiles '../Pak128/**/tram_image/*.png'
echo "==== done ===="