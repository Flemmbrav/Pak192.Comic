@echo off

echo pak192.comic open-source repository compiler for Windows
echo =======================================================
echo.
echo This batch compiles this repository into a new folder
echo called compiled, makeobj.exe must be in root folder.
echo.
echo Checking for makeobj.exe...
echo.
if not exist .\makeobj.exe goto abort

rem Create folder for *.paks or delete all old paks if folder already exists
if exist .\compiled\ (del .\compiled\*.pak) else (md compiled)

echo.
echo -------------------------------------------------------
echo Compile Landscape
echo -------------------------------------------------------
for /f "delims=" %%d in ('dir pakset/landscape /ad /b') do (makeobj pak192 ./compiled/ ./pakset/ ./landscape/%%d/)
echo.
echo -------------------------------------------------------
echo Compile Buildings
echo -------------------------------------------------------
for /f "delims=" %%d in ('dir pakset/buildings /ad /b') do (makeobj pak192 ./compiled/ ./pakset/ ./buildings/%%d/)
makeobj pak192 ./compiled/ ./pakset/ ./buildings/factories/goods/
echo.
echo -------------------------------------------------------
echo Compile infrastructure
echo -------------------------------------------------------
for /f "delims=" %%d in ('dir pakset/infrastructure /ad /b') do (makeobj pak192 ./compiled/ ./pakset/ ./infrastructure/%%d/)
echo.
echo -------------------------------------------------------
echo Compile Vehicles
echo -------------------------------------------------------
for /f "delims=" %%d in ('dir pakset/vehicles /ad /b') do (makeobj pak192 ./compiled/ ./pakset/ ./vehicles/%%d/)
echo.
echo -------------------------------------------------------
echo Compile User Interface
echo -------------------------------------------------------
makeobj pak32 ./compiled/ ./pakset/ ./UI/32/
makeobj pak64 ./compiled/ ./pakset/ ./UI/64/
makeobj pak128 ./compiled/ ./pakset/ ./UI/128/
makeobj pak192 ./compiled/ ./pakset/ ./UI/192/
echo.
echo -------------------------------------------------------
echo Compile Larger Objects
echo -------------------------------------------------------
for /f "delims=" %%d in ('dir pakset/384 /ad /b') do (makeobj pak384 ./compiled/ ./pakset/ ./384/%%d/)
echo.
echo =====================
echo Compilation Complete!
echo =====================
echo.
echo.
echo -------------------------------------------------------
echo Moving Trunk (configs, sound, text)
echo -------------------------------------------------------
robocopy "./pakset/trunk" "./compiled/ ./pakset/"  /s /is /xx
echo.
echo =====================
echo Pakset Complete!
echo =====================
echo.
goto end

:abort
echo ERROR: makeobj not found on root folder.

:end
pause
