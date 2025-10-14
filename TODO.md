# TODO

This file contains topics to undertake to improve NBC

## Primary topics

- The Raspberry PI currently does not have automatic network configuration,
  even if you plug an ethernet cable: you must access a serial console
  through pins 8 and 10
- The game currently only supports being displayed from the network:
  plugging an HDMI cable won't display anything aside a console

## Secondary topics

- the build is pretty long in its current step. There may be packages that
  we could remove
  - the kernel build is especially long. It is likely based on a default
    arm64 defconfig, which could be tailored
- do we really need systemd ? It could save a few hundreds of MB to simply
  use SystemV
