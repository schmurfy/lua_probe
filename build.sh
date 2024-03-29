#!/bin/sh

if [ $# != 1 ]; then
  echo "Usage $0 <luajit_prefix"
  exit 1
fi

LUAJIT_PREFIX=$1
BASEDIR="$(dirname $0)/../.."

CP=$(pwd)
cd deps/libstatgrab/
./autogen.sh
./configure
cd src && make
mkdir -p ../../../statgrab/ext/
cp -f libstatgrab/.libs/libstatgrab.so.6.2.3 ../../../statgrab/ext/libstatgrab.so

cd $CP


# luasocket
# CMAKE_FOLDER="_build_$(uname)"
# mkdir -p deps/luasocket/$CMAKE_FOLDER
# 
# cd deps/luasocket/$CMAKE_FOLDER
# cmake .. -DLUA_LIBRARIES=${LUAJIT_PREFIX}/lib/lua/5.1/ -DLUA_INCLUDE_DIR=${LUAJIT_PREFIX}/include/luajit-2.0/ -DLUA_LIBRARY=${LUAJIT_PREFIX}/lib/ -DCMAKE_INSTALL_PREFIX=${BASEDIR}/_install -DCMAKE_BUILD_TYPE=Release
# make install
# 
# cd $CP
