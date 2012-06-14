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


# Supported Platforms

- Linux


# TODO

- Add support for collectd
- Allow receiving metrics from local applications and retransmit them
- configuration
