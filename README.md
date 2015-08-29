# BatteryDaemon

A little battery logging daemon for **iOS**, written mostly in C but with some Objective-C here and there.

## Why you're doing this

Maninly because:
 * I'm curious about how iOS calculates its "Usage" stats
 * I want to provide something similar to the Android's "Screen usage" statistics
 * I'm having fun doing some *"raw"* C coding

So, here's my method to calculate the real device usage.

## How can I use this

Right now, the only way to really use this thing is to manually start and stop the daemon from MobileTerminal/SSH.

The daemon will correctly flush all the buffers and kill himself if a **SIGINT** will be issued, and it writes its PID at ~/.batterydaemon.pid (the PID file), to ease the stop process.

I will provide a simple application to start/stop the daemon soon.

## Build and install

The Makefile is able to produce a `debug` and `release` build: the default target is the first one.

    # to produce a debug build
    make

    # to produce a release build
    make release

Then upload it via SSH to your device.

A .deb package will be provided soon.
