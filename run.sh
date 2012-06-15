#!/bin/sh

BASEDIR=$(dirname $0)

export LUA_PATH="${BASEDIR}/lib/?.lua;?.lua"
export LUA_CPATH=""

luajit sender.lua
