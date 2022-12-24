#!/bin/bash

#set -e

`rm -rf ../ToBeExported/`
mkdir -p ../ToBeExported/image
mkdir -p ../ToBeExported/tram_image
mkdir -p ../ToBeExported/AddOn/image
mkdir -p ../ToBeExported/AddOn/tram_image

`cp -rf ../pakset/vehicles/narrowgauge/* ../ToBeExported`
`cp -rf ../pakset/vehicles/tram/* ../ToBeExported`
`cp -rf ../pakset/vehicles/track/* ../ToBeExported`

`cp -rf ../AddOn/austrian/vehicles/track/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/belgian/vehicles/* ../ToBeExported/AddOn`
`cp -rf ../AddOn/britain/vehicles/* ../ToBeExported/AddOn`
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

./Special_Colour_Eraser.sh

#`rm -rf ../ToBeExported/`