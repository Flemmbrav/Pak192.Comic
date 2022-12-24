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