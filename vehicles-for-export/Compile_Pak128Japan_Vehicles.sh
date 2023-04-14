#!/bin/bash

#set -e


`rm -rf ../Pak128Japan/`
mkdir -p ../Pak128Japan/image
mkdir -p ../Pak128Japan/tram_image
mkdir -p ../Pak128Japan/AddOn/image
mkdir -p ../Pak128Japan/AddOn/tram_image
mkdir -p ../Pak128JapanSources



`cp -rf ../ToBeExported/image* ../Pak128Japan/`
`cp -rf ../ToBeExported/tram_image* ../Pak128Japan/`
`cp -rf ../ToBeExported/AddOn/image* ../Pak128Japan/AddOn/`
`cp -rf ../ToBeExported/AddOn/tram_image* ../Pak128Japan/AddOn/`

./PictureConverter_Pak128Japan.sh
./DatConverter_Pak128Japan.sh -f

`cp -rf ../makeobj ../Pak128Japan/`
IFS='
	'
directionary="../Pak128Japan/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			#./makeobj pak128 ../Pak128/ "./$dat"
			#./makeobj pak144 ../Pak128Japan/ "./$dat"
			./makeobj pak160 ../Pak128Japan/ "./$dat"
		fi
	done
fi
directionary="../Pak128Japan/AddOn/*.dat"
if [ ${#directionary[@]} -gt 0 ] ; then
	for dat in $directionary ; do
		if [ -f "$dat" ] ; then
			echo "-- Performing Work At: $dat "
			#./makeobj pak128 "./$dat" # &> /dev/null
			#./makeobj pak128 ../Pak128/ "./$dat"
			#./makeobj pak144 ../Pak128Japan/ "./$dat"
			./makeobj pak160 ../Pak128Japan/ "./$dat"
		fi
	done
fi

mkdir -p 

#`rm -rf ../Pak128Japan/image/`
#`rm -rf ../Pak128Japan/tram_image/`
#`rm -rf ../Pak128Japan/ToBeExported/`
#`rm -rf ../Pak128Japan/AddOn/`
#`rm -rf ../Pak128Japan/*.dat`
`mv -f ../Pak128Japan/image/ ../Pak128JapanSources`
`mv -f ../Pak128Japan/tram_image/ ../Pak128JapanSources`
`mv -f ../Pak128Japan/ToBeExported/ ../Pak128JapanSources`
`mv -f ../Pak128Japan/AddOn/ ../Pak128JapanSources`
`mv -f ../Pak128Japan/*.dat ../Pak128JapanSources`
`rm -rf ../Pak128Japan/makeobj`

# pause