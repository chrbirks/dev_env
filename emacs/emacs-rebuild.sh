#!/bin/bash
make clean && ./autogen.sh && ./configure --with-json --with-modules --without-xft --with-xwidgets --with-gconf --with-cairo && make
