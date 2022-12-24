#!/bin/bash

#set -e


`rm -rf ../Pak128/`
mkdir -p ../Pak128/image
mkdir -p ../Pak128/tram_image
mkdir -p ../Pak128/AddOn/image
mkdir -p ../Pak128/AddOn/tram_image



`cp -rf ../ToBeExported/image* ../Pak128/`
`cp -rf ../ToBeExported/tram_image* ../Pak128/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak128/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak128/AddOn/`

./PictureConverter_Pak128.sh
./DatConverter_Pak128.sh -f

`cp -rf ../makeobj ../Pak128/`
IFS='
	'
directionary="../Pak128/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			./makeobj pak128 ../Pak128/ "./$dat"
		fi
	done
fi
directionary="../Pak128/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			./makeobj pak128 ../Pak128/ "./$dat"
		fi
	done
fi

`rm -rf ../Pak128/image/`
`rm -rf ../Pak128/tram_image/`
`rm -rf ../Pak128/AddOn/`
`rm -rf ../Pak128/*.dat`
`rm -rf ../Pak128/makeobj`

# pause