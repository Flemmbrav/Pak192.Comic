#!/bin/bash

set -e

echo 'pak192.comic open-source repository compiler for Linux'
echo -e '======================================================\n'

echo 'This bash compiles the theme into a new folder'
echo -e 'called themes, makeobj must be in root folder.\n'

echo -n 'Checking for makeobj... '

if [ ! -f 'makeobj' ]; then
    echo 'ERROR: makeobj not found in root folder.'
    exit 1
fi

echo -e 'OK\n'

mkdir themes
./makeobj pak64 themes/menu.pak192comic.pak theme/pak192comic/theme.dat
./makeobj pak64 themes/menu.pak192comicxxl.pak theme/pak192comicxxl/theme.dat
cp -v ./theme/*.tab ./themes/ 
zip -r themes.zip themes


echo '======================================================'
echo 'theme complete!'
echo '======================================================'