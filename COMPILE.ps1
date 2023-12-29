#!/usr/bin/env powershell

echo 'pak192.comic open-source repository compiler for Windows'
echo "========================================================`n"

echo 'This powershell compiles this repository into a new'
echo "folder called compiled, makeobj must be in root folder.`n"

# Does all the heavy work
# @param $paksize pakset size
# @param $msg log message
# @param $glob string with glob where to search dats
function compile($paksize, $msg, $glob) {
    echo '--------------------------------------------------------'
    echo "Compiling $msg..."

    $index=1
    $dats=Get-ChildItem $glob
    $size=($dats | Measure-Object).Count

    foreach ($dat in $dats) {
        # hash the dat file Get-FileHash only available on version 3
        try {
            $dathash=($dat | Get-FileHash -Algorithm SHA256).Hash
        } catch {
            $dathash=(CertUtil -hashfile $dat.FullName SHA256)[1].replace(' ', '')
        }

        # obtain all image names inside the dat file
        $images=@(Get-Content $dat | %{
            if ($_ -match '^([^#]*image\[|cursor|icon)') {
                if ($_.Split('=')[1] -match '(?:\.+[\/\\])*[\w\-)(\/\\]+') {
                    if ($Matches[0] -ne '-') {
                        $dat.Directory.toString() + '\' + $Matches[0] + '.png'
                    }
                }
            }
        } | Select-Object -Unique)

        if ($images.Count -gt 0) {
            # hash all the images
            $imghash=@($images | ForEach-Object {
                try {
                    $path=$_
                    (Get-FileHash -Algorithm SHA256 -Path $_).Hash
                } catch {
                    (CertUtil -hashfile $path SHA256)[1].replace(' ', '')
                }
            })
        }

        # convert to linux style for compatibility between systems
        $relative=($dat | Resolve-Path -Relative).Substring(2).Replace('\', '/')

        # get the hashes from the previous run
        $validate=@(Get-Content "$csv" | %{ if ($_ -match $relative) { $_.Split(',') } })

        # assume no recompilation necessary
        $recompile=$false

        # check hashes and number of images
        if ($validate.Count -eq 0 -or $dathash -ne $validate[1] -or ($validate.Count - 2) -ne $imghash.Count) {
            $recompile=$true
        } else {
            # check all image hashes
            foreach ($hash in $imghash) {
                if (!($validate -contains $hash)) {
                    $recompile=$true
                }
            }
        }

        # recompiling if necessary
        if ($recompile) {
            ./makeobj.exe "pak$paksize" ./compiled/ "$relative" > $null 2> $null
            if ($LASTEXITCODE -gt 0) {
                echo "Error: Makeobj returned an error for $relative. Aborting..."
                rm "$csv.in"
                exit $LASTEXITCODE
            }
        }

        # put the hashes in the $csv.in file
        echo "$relative,$dathash,$($imghash -join ',')" >> "$csv.in"

        Write-Progress -Activity "Compiling $msg" -Status "$relative" -PercentComplete (100*$index/$size)
        $index++
    }
}

Write-Host -NoNewline 'Checking for makeobj... '

if (!(Test-Path makeobj.exe)) {
    echo 'ERROR: makeobj not found in root folder.'
    exit 2
}

echo 'OK`n'

# Create folder for *.paks or delete all old paks if folder already exists
if (!(Test-Path compiled)) {
    mkdir compiled > $null
}

$csv='compiled/compile.csv'

# No file from last run, create empty one
if (!(Test-Path "$csv")) {
    echo '' > "$csv"
}
echo '# This file allows the compile script to only recompile changed files' > "$csv.in"

compile '192' 'Landscape' 'pakset/landscape/ground/*.dat'
compile '192' 'Landscape' 'pakset/landscape/ground_obj/*.dat'
compile '192' 'Landscape' 'pakset/landscape/tree/*.dat'
compile '48' 'Landscape' 'pakset/landscape/pedestrians/*.dat'
compile '192' 'Buildings' 'pakset/buildings/**/*.dat'
compile '192' 'Infrastructure' 'pakset/infrastructure/**/*.dat'
compile '192' 'Vehicles' 'pakset/vehicles/**/*.dat'
compile '192' 'Goods' 'pakset/buildings/factories/goods/*.dat'
compile '32' 'User Interface' 'pakset/UI/32/*.dat'
compile '64' 'User Interface' 'pakset/UI/64/*.dat'
compile '128' 'User Interface' 'pakset/UI/128/*.dat'
compile '192' 'User Interface' 'pakset/UI/192/*.dat'
compile '384' 'Larger Objects' 'pakset/384/**/*.dat'
compile '48' 'Smaller Objects' 'calculated/pakset/48/**/**/*.dat'

# remove the old csv
mv -Force "$csv.in" "$csv"

echo '--------------------------------------------------------'
echo "Moving Trunk (configs, sound, text)`n"

Copy-Item pakset/trunk/* compiled -Recurse -Force

echo '========================================================'
echo 'Pakset Complete!'
echo '========================================================'
