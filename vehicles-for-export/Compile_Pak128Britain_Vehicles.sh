#!/bin/bash

#set -e


`rm -rf ../Pak128Britain/`
mkdir -p ../Pak128Britain/image
mkdir -p ../Pak128Britain/tram_image
mkdir -p ../Pak128Britain/AddOn/image
mkdir -p ../Pak128Britain/AddOn/tram_image



`cp -rf ../ToBeExported/image* ../Pak128Britain/`
`cp -rf ../ToBeExported/tram_image* ../Pak128Britain/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak128Britain/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak128Britain/AddOn/`

./PictureConverter_Pak128Britain.sh
./DatConverter_Pak128Britain.sh -f

`cp -rf ../makeobj ../Pak128Britain/`
IFS='
	'
directionary="../Pak128Britain/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			./makeobj pak128 ../Pak128Britain/ "./$dat"
		fi
	done
fi
directionary="../Pak128Britain/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			./makeobj pak128 ../Pak128Britain/ "./$dat"
		fi
	done
fi

`rm -rf ../Pak128Britain/image/`
`rm -rf ../Pak128Britain/tram_image/`
`rm -rf ../Pak128Britain/AddOn/`
`rm -rf ../Pak128Britain/*.dat`
`rm -rf ../Pak128Britain/makeobj`

# pause