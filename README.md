# What ?

For a long time now I wanted a lightweight client to send system metrics from, after a lot of trial & error
I finally settled my choice on lua and more specifically luajit and here it is.


# Goals

- Provide a lightweight metrics provider (cpu, memory, ...)
- Provide a self contained application (I wish there was a bundler equivalent for lua, let me know if you know one)

# Current state

- libstatgrab is used to collect the values via ffi
- luasocket is used to send udp packets to a central server
- implemented [ESTP](https://github.com/estp/estp/blob/master/specification.rst) protocol
- the application can already send some statistics on a fixed interval


# Tested Platforms

- Linux 2.6
- FreeBSD 8
- OpenBSD 5.0


# Dependencies

- CMake 2.8+.4+
- autoconf & automake
- luajit 2.0.0.beta10+


# Install

```bash
git clone git://github.com/schmurfy/lua_probe.git
cd lua_probe
git submodule update --init
./build.sh <luajit_install_prefix>
./run.sh
```

luasocket is installed inside the lua_probe folder (deps/_install) and 
libstatgrab shared library is copied to statgrab/ext.

Once you have compiled everything and the run.sh script is working you can remove some folders:
(I plan to use on soekris hardware were space is a concern)

- deps/luasocket/
- deps/libstatgrab/
- .git/


# TODO

- Add support for collectd
- Allow receiving metrics from local applications and retransmit them
- configuration
