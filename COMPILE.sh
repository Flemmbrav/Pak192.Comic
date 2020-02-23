#!/bin/bash

echo 'pak192.comic open-source repository compiler for Linux'
echo -e '======================================================\n'

echo 'This bash compiles this repository into a new folder'
echo -e 'called compiled, makeobj must be in root folder.\n'

# Prints a progress bar with percentage
# @param $1 current index
# @param $2 total elements
# @param $3 current dat file being processed
progressbar() {
    # 3 chars at the beginning + 7 at the end
    local width=$(($(tput cols) - 10))
    local percent=$((100 * $1 / $2))
    local loading=$(($width * $1 / $2))

    tput cuu1
    tput el
    echo "  $3"
    echo -ne '  ['
    for (( i = 0; i < $loading; i++ )); do echo -ne '#'; done
    for (( i = 0; i < $(($width - $loading)); i++ )); do echo -ne '-'; done
    printf '] %3.1u%%\r' $percent
}

# Does all the heavy work
# @param $1 pakset size
# @param $2 log message
# @param $* list of files to compile
compile() {
    echo '------------------------------------------------------'
    echo -e "Compiling $2...\n"

    local index=1
    local size=($3)
    local size=${#size[@]}

    for dat in $3; do
        # get directory where the dat file is located
        local dir=$(dirname "$dat")

        # hash the dat file
        local IFS=' '
        local dathash=($(sha256sum "$dat"))
        local dathash=$dathash
        local IFS=,

        # obtain all image names inside the dat file
        local images=$(awk -F= '
            BEGIN {
                IGNORECASE=1
            }
            {
                if (/^([^#]*image\[|cursor|icon)/) {
                    match($2, /(\.+[\/\\])*[a-z0-9\/\-_\\()]+/);
                    images[substr($2, RSTART, RLENGTH)]++
                }
            }
            END {
                for (img in images) {
                    if (img != "-") {
                        printf "'$dir'/%s.png,", img
                    }
                }
            }' "$dat")

        if [[ ! -z $images ]]; then
            # hash all the images
            tempsha=$(sha256sum $images)

            if [[ $? != 0 ]]; then
                echo -e "\x1B[33mWarning: Failed to get one or more hashes on $dat\x1B[0m"
            fi

            local imghash=($(printf '%s %s\n' $tempsha | awk '{ printf "%s,", $1 }'))
        fi

        # get the hashes from the previous run
        local validate=($(awk -F, "\$1 == \"$dat\"" "$csv"))

        # assume no recompilation necessary
        local recompile=0

        # check hashes and number of images
        if [[ $dathash != ${validate[1]} || $((${#validate[*]} - 2)) != ${#imghash[*]} ]]; then
            local recompile=1
        else
            # check all image hashes
            for hash in ${imghash[*]}; do
                if [[ ! "${validate[*]}" =~ $hash ]]; then
                    local recompile=1
                fi
            done
        fi

        # recompiling if necessary
        if [[ $recompile == 1 ]]; then
            ./makeobj pak$1 ./compiled/ "./$dat" &> /dev/null
            if [[ $? != 0 ]]; then
                echo "Error: Makeobj returned an error for $dat. Aborting..."
                rm "$csv.in"
                exit $?
            fi
        fi

        # put the hashes in the $csv.in file
        echo "$dat,$dathash,${imghash[*]}" >> "$csv.in"

        progressbar $index $size $dat
        local index=$(( $index + 1 ))
    done

    # jump line because of progress bar
    echo -ne '\n'
}

echo -n 'Checking for makeobj... '

if [ ! -f 'makeobj' ]; then
    echo 'ERROR: makeobj not found in root folder.'
    exit 1
fi

echo -e 'OK\n'

# Create folder for *.paks or delete all old paks if folder already exists
if [ ! -d 'compiled' ]; then
    mkdir compiled
fi

csv=compiled/compile.csv

# No file from last run, create empty one
if [ ! -f $csv ]; then
    echo '' > "$csv"
fi
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

# Finished successfully, get rid of old csv
mv "$csv.in" "$csv"

echo -e '------------------------------------------------------'
echo -e 'Moving Trunk (configs, sound, text)\n\n'

cp -r pakset/trunk/* compiled

echo '======================================================'
echo 'Pakset complete!'
echo '======================================================'
