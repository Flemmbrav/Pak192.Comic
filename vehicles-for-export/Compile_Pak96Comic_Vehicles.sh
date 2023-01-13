#!/bin/bash

#set -e


`rm -rf ../Pak96Comic/`
mkdir -p ../Pak96Comic/image
mkdir -p ../Pak96Comic/tram_image
mkdir -p ../Pak96Comic/AddOn/image
mkdir -p ../Pak96Comic/AddOn/tram_image



`cp -rf ../ToBeExported/image* ../Pak96Comic/`
`cp -rf ../ToBeExported/tram_image* ../Pak96Comic/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak96Comic/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak96Comic/AddOn/`

./PictureConverter_Pak96Comic.sh
./DatConverter_Pak96Comic.sh -f

`cp -rf ../makeobj ../Pak96Comic/`
IFS='
	'
directionary="../Pak96Comic/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak112 ../Pak96Comic/ "./$dat"
		fi
	done
fi
directionary="../Pak96Comic/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			./makeobj pak112 ../Pak96Comic/ "./$dat"
		fi
	done
fi

`rm -rf ../Pak96Comic/image/`
`rm -rf ../Pak96Comic/tram_image/`
`rm -rf ../Pak96Comic/ToBeExported/`
`rm -rf ../Pak96Comic/AddOn/`
`rm -rf ../Pak96Comic/*.dat`
`rm -rf ../Pak96Comic/makeobj`

# pause