#!/bin/bash

#set -e


`rm -rf ../Pak64German/`
mkdir -p ../Pak64German/image
mkdir -p ../Pak64German/tram_image
mkdir -p ../Pak64German/AddOn/image
mkdir -p ../Pak64German/AddOn/tram_image



`cp -rf ../ToBeExported/image* ../Pak64German/`
`cp -rf ../ToBeExported/tram_image* ../Pak64German/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak64German/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak64German/AddOn/`

./PictureConverter_Pak64German.sh
./DatConverter_Pak64German.sh -f

`cp -rf ../makeobj ../Pak64German/`
IFS='
	'
directionary="../Pak64German/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak64 ../Pak64German/ "./$dat"
		fi
	done
fi
directionary="../Pak64German/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak64 ../Pak64German/ "./$dat"
		fi
	done
fi

`rm -rf ../Pak64German/image/`
`rm -rf ../Pak64German/tram_image/`
`rm -rf ../Pak64German/AddOn/`
`rm -rf ../Pak64German/*.dat`
`rm -rf ../Pak64German/makeobj`

# pause