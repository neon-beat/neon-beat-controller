# Neon Beat controller

This repository contains the build system for the Neon Beat controller
(NBC).
NBC is a physical platform exposing all features needed to run a game of
Neon Beat. It exposes the following main features:
- an access point allowing all buzzers to connect
- the Neon Beat backend, containing all the logic to run the game
- the Neon Beat players frontend, exposing the main interface during a game

## Hardware

The Neon Beat controller default target is a Raspberry PI 4. On top of the
main board, the controller needs a dedicated wireless dongle, as the
embedded wireless interface is not capable enough to handle many concurrent
buzzers. The controller currently supports the TP Link AC 1300 USB dongle

## Software

The repository contains a whole build system based on
[Buildroot](https://buildroot.org/). In order to build the firmware, run
the following commands on your host:

```sh
$ git clone --recursive https://github.com/neon-beat/neon-beat-controller
$ cd neon-beat-controller
$ make
```

The build will take between 20 minutes and a hour, depending on your
machine. Once done, you will have a writable SD card image in
`output/images/sdcard.img`. Plug a SD card onto your computer, and write
the image on to it (taking care of replacing `/dev/sdc` with the relevant
device):

```sh
$ dd if=output/images/sdcard.img of=/dev/sdc status=progress
```

Once done, plug the SD card onto the Raspberry PI and power it. With the
current project state, you should at least be able to access a console if
you connect a FTDI cable on pins 8 and 10.

