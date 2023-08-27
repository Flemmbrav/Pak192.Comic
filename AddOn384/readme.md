## Welcome to the 384-folder.

This folder will be build as pak384, but the files will be used in the pak192.comic as well.

## Why is this a thing?

The other .pak files use images sized 192x192 pixels.
Hence the name of the pakset.
But sometimes one might want to have objects with images bigger than that.
Examples are planes with wings wider than a tile or elevated ways with a fence extending over the tile.

## How does it work?

The .pak files will use images of the dimension of 384x384 pixels.
When loaded into simutrans, they'll be fully drawn extending the space to the bottom right.
Thus most files define an offset after each image bringing it back in position.

## Offsetting images

An example for an image definition from this folder:

> BackImage[11][0][0][0][0][0]=./images/station/1890_station_hall.3.5,-192,-96

This file uses the image ./images/station/1890_station_hall.3.5 as BackImage[11][0][0][0][0][0]. The image will displayed 192 pixels to the left as well as 96 pixels to the top.