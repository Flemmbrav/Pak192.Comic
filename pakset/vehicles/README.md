# Vehicle convention for Pak192.Comic

## Name of the vehicle

The name of the vehicles builds from the following aspects, linked by underscores:
0. The type of way. It's okay to use "Narrowgauge" instead of "Narrowgauge_Track"
1. The type of vehicle
2. The transported good
3. The year of introduction
4. Optional: a known name of the vehicle to help identifying it
5. In case there are multiple vehicles with the same name, add an additional counter
Examples:
1. Narrowgauge_Car_Agriculture_1935
2. Narrowgauge_Passenger_Train_2015_Komet_1
3. Track_Car_Piece_Goods_1986_Hbbills_305
4. Track_Lokomotive_2003_BR189

## Name and position of the .dat file

All .dat files are positioned in the main vehicles/waytype folder.
The .dat file has the same name as the vehicle, except there being no way in front, as that's a given.
You can merge multiple vehicles in the same .dat file, but only if the .dat file name is leagal and holds true for all the vehicles in the file.
Examples for good names of .dat files:
1. Passenger_Train_1990_Dostos.dat
2. Lokomotive_1993_OBB1014.dat
Examples for bad names of .dat files:
1. Tram_Leipzig.dat
2. vt17.dat

## Name and position of the .png files

The .png file shares either the name of the vehicle or the dat file.
In case of latter, all vehicles of that .dat file shall be includet.
All images are hosted in a sub folder called "image".
Examples of good .png file references:
1. ./image/Lokomotive_2003_BR189.png
3. ./image/Electric_1999_ICE3.png
Examples of bad .png file references:
2. ./image/BR_120_101.png
3. ./DB_FV/Electric_1999_ICE3.png
4. Electric_1999_ICE3.png