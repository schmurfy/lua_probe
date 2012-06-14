#!/bin/sh

# user config
LUAJIT_PREFIX="/usr/local/lua"
# end of user config


BASEDIR="$(dirname $0)/../.."

CP=$(pwd)
cd deps/libstatgrab/
./autogen.sh
./configure
cd src && make
mkdir -p ../../../statgrab/ext/
cp -f libstatgrab/.libs/libstatgrab.so ../../../statgrab/ext/

cd $CP


# luasocket
CMAKE_FOLDER="_build_$(uname)"
mkdir -p deps/luasocket/$CMAKE_FOLDER

cd deps/luasocket/$CMAKE_FOLDER
cmake .. -DLUA_LIBRARIES=${LUAJIT_PREFIX}/lib/lua/5.1/ -DLUA_INCLUDE_DIR=${LUAJIT_PREFIX}/include/luajit-2.0/ -DLUA_LIBRARY=${LUAJIT_PREFIX}/lib/ -DCMAKE_INSTALL_PREFIX=${BASEDIR}/_install -DCMAKE_BUILD_TYPE=Release
make install

cd $CP
