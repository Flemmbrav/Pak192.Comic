#!/bin/bash

#set -e

`rm -rf ../Pak128Britain/`
`rm -rf ../ToBeExported/`
mkdir -p ../Pak128Britain/image
mkdir -p ../Pak128Britain/tram_image
mkdir -p ../Pak128Britain/AddOn/image
mkdir -p ../Pak128Britain/AddOn/tram_image
mkdir -p ../ToBeExported/image
mkdir -p ../ToBeExported/tram_image
mkdir -p ../ToBeExported/AddOn/image
mkdir -p ../ToBeExported/AddOn/tram_image



`cp -rf ../pakset/vehicles/narrowgauge/* ../ToBeExported`
`cp -rf ../pakset/vehicles/tram/* ../ToBeExported`
`cp -rf ../pakset/vehicles/track/* ../ToBeExported`

`cp -rf ../ToBeExported/image* ../Pak128Britain/`
`cp -rf ../ToBeExported/tram_image* ../Pak128Britain/`

`cp -rf ../AddOn/austrian/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/belgian/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/czech/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/danish/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/french/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/german/vehicles/tram/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/german/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/german/vehicles/subway/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/japanese/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/luxembourgian/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/norwegian/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/polish/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/swiss/vehicles/narrowgauge/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/swiss/vehicles/tram/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/swiss/vehicles/track/* ../ToBeExported/AddOn`



`cp -rf ../ToBeExported/AddOn/image* ../Pak128Britain/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak128Britain/AddOn/`

./DatConverter_Pak128Britain.sh -f
./PictureConverter_Pak128Britain.sh
`cp -rf ../makeobj ../Pak128Britain/`
#./Compile_Converted_Pak128Britain.sh
#`cd ../Pak128Britain/`


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
`rm -rf ../ToBeExported/`
`rm -rf ../Pak128Britain/ToBeExported/`



#./makeobj pak128
#`rm -rf ./makeobj`
# readallfiles 'converted_image/image/*.png'

# pause