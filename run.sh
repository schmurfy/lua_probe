#!/bin/sh

BASEDIR=$(dirname $0)

export LUA_PATH="${BASEDIR}/deps/_install/lib/lua/?.lua;?.lua"
export LUA_CPATH="${BASEDIR}/deps/_install/lib/lua/?.so;statgrab/?.so"

luajit sender.lua
