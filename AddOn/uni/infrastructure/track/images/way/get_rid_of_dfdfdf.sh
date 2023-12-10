
#!/bin/bash

#set -e

convertpng() {

	oldimage=$1
	convert $oldimage -fill '#DFDFDF' -opaque '#DFDFDE' $oldimage

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


echo "==== getting rid of the colour DFDFDF ===="
readallfiles '*.png'
#readallfiles '../Pak128/image/*.png'
#readallfiles '../Pak128/tram_image/*.png'
#readallfiles '../Pak128/**/image/*.png'
#readallfiles '../Pak128/**/tram_image/*.png'
echo "==== done ===="