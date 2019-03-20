# @echo off

echo pak192.comic open-source repository compiler for Windows
echo =======================================================
echo
echo This batch compiles this repository into a new folder
echo called compiled, makeobj.exe must be in root folder.
echo
echo Checking for makeobj.exe...

if [ -f "./makeobj" ]; then
    echo "makeobj found"
else
    echo "ERROR: makeobj not found"
    exit 1 
fi
echo  Create folder for *.paks or delete all old paks if folder already exists
# if exist .\compiled\ (del .\compiled\*.pak) else (md compiled)

if [ -d "compiled" ]
then
    rm compiled
else
    mkdir compiled
fi
   
echo
echo -------------------------------------------------------
echo Compile Objects
echo -------------------------------------------------------

# for /f "delims=" %%d in ('dir pakset\landscape /ad /b') do (makeobj pak192 ./compiled/ ./pakset/landscape/%%d/)
for i in ./pakset/landscape/* ./pakset/buildings/* ./pakset/buildings/factories/goods/ ./pakset/infrastructure/* ./pakset/vehicles/*
do
    [ -d "$i" ] || continue
    ./makeobj pak192 ./compiled/ $i/
done

	 
echo
echo -------------------------------------------------------
echo Compile User Interface
echo -------------------------------------------------------
./makeobj pak32 ./compiled/ ./pakset/UI/32/
./makeobj pak64 ./compiled/ ./pakset/UI/64/
./makeobj pak128 ./compiled/ ./pakset/UI/128/
./makeobj pak192 ./compiled/ ./pakset/UI/192/
echo
echo -------------------------------------------------------
echo Compile Larger Objects
echo -------------------------------------------------------
for i in ./pakset/384/*
do
#	 for /f "delims=" %%d in ('dir pakset\384 /ad /b') do (makeobj pak384 ./compiled/ ./pakset/384/%%d/)
    ./makeobj pak384 ./compiled/ $i/
done
						     
echo
echo =====================
echo Compilation Complete!
echo =====================
echo
echo
echo -------------------------------------------------------
echo "Moving Trunk (configs, sound, text)"
echo -------------------------------------------------------
# robocopy  .\pakset\trunk .\compiled\  /s /is /xx
cp -r pakset/trunk/* compiled
echo
echo =====================
echo Pakset Complete!
echo =====================
echo
