# TODO

This file contains topics to undertake to improve NBC

## Primary topics

- The Raspberry PI currently does not have automatic network configuration,
  even if you plug an ethernet cable: you must access a serial console
  through pins 8 and 10
- The game currently only supports being displayed from the network:
  plugging an HDMI cable won't display anything aside a console
- The backend is missing a systemd service to automatically start
- NBC is missing some avahi configuration so we can use directly
  "nbc.local" in a web browser.
- Separate the database raw data from the couchdb container: ideally
  couchdb database lives in a dedicated volume based on a dedicated
  partition on the sd card.

## Secondary topics

- the build is pretty long in its current step. There may be packages that
  we could remove
  - the kernel build is especially long. It is likely based on a default
    arm64 defconfig, which could be tailored
- do we really need systemd ? It could save a few hundreds of MB to simply
  use SystemV
- importing a docker image for CouchDB is really a hack, and it consumes a
  lot of disk space, resulting in long SD card flashing time. Yocto people
  have [managed to cross-compile
  it](https://layers.openembedded.org/layerindex/recipe/454923/), it would
  be worth analysing the corresponding bibtake recipe and transpose it to a
  buildroot package.
- define a proper SSH access policy. There is currently a passwordless root
  policy configured, which is of course not a long term solution. Something
  with a way to provide a set of public keys at build time ?
