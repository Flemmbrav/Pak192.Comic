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
