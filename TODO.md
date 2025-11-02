# TODO

This file contains topics to undertake to improve NBC

## Primary topics

- The game currently only supports being displayed from the network:
  plugging an HDMI cable won't display anything aside a console
- Separate the database raw data from the couchdb container: ideally
  couchdb database lives in a dedicated volume based on a dedicated
  partition on the sd card.
- Define a proper way to access the admin frontend: currently the admin
  controller (smartphone, PC, whatever) needs to be on the same network as
  the NBC. This is not very convenient. Maybe allow the controller to
  connect to nb_ap ?

## Secondary topics

- the build is pretty long in its current step. There may be packages that
  we could remove
  - the kernel build is especially long. It is likely based on a default
    arm64 defconfig, which could be tailored
- do we really need systemd ? It could save a few hundreds of MB to simply
  use SystemV
- define a proper SSH access policy. There is currently a passwordless root
  policy configured, which is of course not a long term solution. Something
  with a way to provide a set of public keys at build time ?
