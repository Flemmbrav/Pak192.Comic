#!/bin/bash

set -e

echo 'pak192.comic open-source repository AddOn compiler for Unix'
echo -e '======================================================\n'

echo 'This bash compiles this repository into a new folder'
echo -e 'called compiled, makeobj must be in root folder.\n'

# Prints a progress bar with percentage
# @param $1 current index
# @param $2 total elements
# @param $3 current dat file being processed
rogressbar() {
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

        if [ -f "$dat" ] ; then

            ./makeobj pak$1 ./compiled_converted/ "./$dat" &> /dev/null
                if [[ $? != 0 ]]; then
                    echo "Error: Makeobj returned an error for $dat. Aborting..."
                fi
        fi

        # get directory where the dat file is located
        #    local dir=$(dirname "$dat")

            # hash the dat file
        #    local IFS=' '
         #   local dathash=($(sha256sum "$dat"))
          #  local dathash=$dathash
           # local IFS=,

            # obtain all image names inside the dat file
           # local images=$(awk -F= '
            #    BEGIN {
             #       IGNORECASE=1
              #  }
               # {
                #    if (/^([^#]*image\[|cursor|icon)/) {
                 #       match($2, /(\.+[\/\\])*[a-z0-9\/\-_\\()]+/);
                  #      images[substr($2, RSTART, RLENGTH)]++
        #            }
         #       }
          #      END {
           #         for (img in images) {
            #            if (img != "-") {
             #               printf "'$dir'/%s.png,", img
              #          }
               #     }
   #             }' "$dat")
#
 #           if [[ ! -z $images ]]; then
  #              # hash all the images
   #             tempsha=$(sha256sum $images)
#
 #               if [[ $? != 0 ]]; then
  #                  echo -e "\x1B[33mWarning: Failed to get one or more hashes on $dat\x1B[0m"
   #             fi
#
 #               local imghash=($(printf '%s %s\n' $tempsha | awk '{ printf "%s,", $1 }'))
  #          fi
#
 #           # get the hashes from the previous run
  #          local validate=($(awk -F, "\$1 == \"$dat\"" "$csv"))
#
 #           # assume no recompilation necessary
  #          local recompile=0
#
 #           # check hashes and number of images
  #          if [[ $dathash != ${validate[1]} || $((${#validate[*]} - 2)) != ${#imghash[*]} ]]; then
   #             local recompile=1
    #        else
     #           # check all image hashes
      #          for hash in ${imghash[*]}; do
       #             if [[ ! "${validate[*]}" =~ $hash ]]; then
        #                local recompile=1
         #           fi
          #      done
           # fi
#
 #           # recompiling if necessary
  #          if [[ $recompile == 1 ]]; then
   #             
    #       set -e o pipefail
    #                echo -e "\x1B[33mError: Can not compile $dat\x1B[0m"
    #                rm "$csv.in"
    #                exit $?
    #            fi
    #        fi

    #        # put the hashes in the $csv.in file
     #       echo "$dat,$dathash,${imghash[*]}" >> "$csv.in"

            #if [ $TERM ] ; then
            #    progressbar $index $size $dat
            #fi
      #      local index=$(( $index + 1 ))
      #  fi
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
if [ ! -d 'compiled_converted_addons' ]; then
    mkdir compiled_converted_addons
fi

csv=compiled_converted_addons/compiled_addons.csv

# No file from last run, create empty one
if [ ! -f $csv ]; then
    echo '' > "$csv"
fi
echo '# This file allows the compile script to only recompile changed files' > "$csv.in"


compile '192' 'AddOns 1/5' 'calculated/AddOn/*.dat'
compile '192' 'AddOns 2/5' 'calculated/AddOn/**/*.dat'
compile '192' 'AddOns 3/5' 'calculated/AddOn/**/**/*.dat'
compile '192' 'AddOns 4/5' 'calculated/AddOn/**/**/**/*.dat'
compile '192' 'AddOns 5/5' 'calculated/AddOn/**/**/**/**/*.dat'

#compile '192' 'British Stuff 1/2' 'calculated/AddOn/britain/**/*.dat'
#compile '192' 'British Stuff 2/2' 'calculated/AddOn/britain/**/**/*.dat'
#compile '192' 'Austrian Stuff' 'calculated/AddOn/austrian/**/**/*.dat'
#compile '192' 'British Infrastrukture' 'calculated/AddOn/britain/Infrastruktur/*.dat'
#compile '192' 'British Vehicles' 'calculated/AddOn/britain/vehicles/**/*.dat'
#compile '192' 'Belgish Stuff' 'calculated/AddOn/belgian/**/*.dat'
#compile '192' 'Czech Vehicles' 'calculated/AddOn/czech/vehicles/**/*.dat'
#compile '192' 'Danish Stuff' 'calculated/AddOn/danish/**/*.dat'
#compile '192' 'French Stuff' 'calculated/AddOn/french/**/*.dat'
#compile '192' 'German Vehicles' 'calculated/AddOn/german/vehicles/**/*.dat'
#compile '192' 'Japanese Stuff' 'calculated/AddOn/japanese/**/*.dat'
#compile '192' 'Luxembourgian Stuff' 'calculated/AddOn/luxembourgian/vehicles/*.dat'
#compile '192' 'Norwegian Stuff 1/2' 'calculated/AddOn/norwegian/**/*.dat'
#compile '192' 'Norwegian Stuff 2/2' 'calculated/AddOn/norwegian/**/**/*.dat'
#compile '192' 'Swiss Stuff' 'calculated/AddOn/swiss/**/**/*.dat'

# Finished successfully, get rid of old csv
mv "$csv.in" "$csv"

echo '======================================================'
echo 'AddOn folder complete!'
echo '======================================================'
