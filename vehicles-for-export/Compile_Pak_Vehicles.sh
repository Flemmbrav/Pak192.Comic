#!/bin/bash

#set -e


`rm -rf ../Pak/`
mkdir -p ../Pak/image
mkdir -p ../Pak/tram_image
mkdir -p ../Pak/AddOn/image
mkdir -p ../Pak/AddOn/tram_image



`cp -rf ../ToBeExported/image* ../Pak/`
`cp -rf ../ToBeExported/tram_image* ../Pak/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak/AddOn/`

./PictureConverter_Pak.sh
./DatConverter_Pak.sh -f

`cp -rf ../makeobj ../Pak/`
IFS='
	'
directionary="../Pak/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak64 ../Pak/ "./$dat"
		fi
	done
fi
directionary="../Pak/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak64 ../Pak/ "./$dat"
		fi
	done
fi

`rm -rf ../Pak/image/`
`rm -rf ../Pak/tram_image/`
`rm -rf ../Pak/ToBeExported/`
`rm -rf ../Pak/AddOn/`
`rm -rf ../Pak/*.dat`
`rm -rf ../Pak/makeobj`

# pause