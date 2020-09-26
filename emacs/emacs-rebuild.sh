#!/usr/bin/env bash

cd ../../emacs-dev
git fetch

echo News since HEAD:
git diff HEAD..FETCH_HEAD -- etc/NEWS

git pull --ff-only
git clean -dfx

make clean && ./autogen.sh && ./configure --with-modules --without-xft --with-xwidgets --with-gconf --with-cairo --with-harfbuzz && make

echo Build finished
./src/emacs -Q
