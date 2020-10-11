# Vehicle convention for Pak192.Comic Extended

## Name of the vehicle

The name of the vehicles builds from the following aspects, linked by underscores:

- The type of way. It's okay to use "Narrowgauge" instead of "Narrowgauge_Track"
- The type of vehicle
- The transported good
- The year of introduction
- Optional: a known name of the vehicle to help identifying it
- In case there are multiple vehicles with the same name, add an additional counter

Examples:

- Narrowgauge_Car_Agriculture_1935
- Narrowgauge_Passenger_Train_2015_Komet_1
- Track_Car_Piece_Goods_1986_Hbbills_305
- Track_Lokomotive_2003_BR189

## Name and position of the .dat file

All .dat files are positioned in the main vehicles/waytype folder.
The .dat file has the same name as the vehicle, except there being no way in front, as that's a given.
You can merge multiple vehicles in the same .dat file, but only if the .dat file name is leagal and holds true for all the vehicles in the file.
Examples for good names of .dat files:

- Passenger_Train_1990_Dostos.dat
- Lokomotive_1993_OBB1014.dat

Examples for bad names of .dat files:

- Tram_Leipzig.dat
- vt17.dat

## Name and position of the .png files

The .png file shares either the name of the vehicle or the dat file.
In case of latter, all vehicles of that .dat file shall be includet.
All images are hosted in sub folders for every supported livery by the vehicle.
Examples of good .png file references:

- ./DB_Cargo/Lokomotive_2003_BR189.png
- ./MRCE/Lokomotive_2003_BR189.png
- ./DB_FV/Electric_1999_ICE3.png

Examples of bad .png file references:

- ./image/Lokomotive_2003_BR189.png
- ./image/BR_120_101.png
- ./DB_FV/ICE3.png
- Electric_1999_ICE3.png

## Catering

- catering_level=0: no catering
- catering_level=1: trolly with snacks and coffee or a vending machine
- catering_level=2: mini build in bistro with snacks and coffee 
- catering_level=3: bistro with hot food and dining
- catering_level=4: full size restaurant
- catering_level=5: luxury restaurant with freshly cooked meals and flamboyant dishes
- catering_level=5: disco car with a cocktailbar