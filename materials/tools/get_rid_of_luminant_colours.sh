
#!/bin/bash

#set -e

convertpng() {

	oldimage=$1
	convert $oldimage -fill '#DFDFDF' -opaque '#DFDFDE' -fill '#C9C9C9' -opaque '#C9C9C8' -fill '#B3B3B3' -opaque '#B3B3B2' -fill '#9B9B9B' -opaque '#9B9B9C' -fill '#6B6B6B' -opaque '#6B6B6C' $oldimage

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


echo "==== Swapping player colours ===="
readallfiles '*.png'
#readallfiles '../Pak128/image/*.png'
#readallfiles '../Pak128/tram_image/*.png'
#readallfiles '../Pak128/**/image/*.png'
#readallfiles '../Pak128/**/tram_image/*.png'
echo "==== done ===="