#!/bin/bash

set -e

# This script assumes that
# - the NBC is up and running
# - you have deployed your SSH public key onto it
# - you can ping nbc.local
# - you have set an entry for the NBC in your ssh_config to access it with
# a bare "ssh nbc"

SCRIPT_DIR=$(dirname "$(realpath $0)")
TOP_DIR=${SCRIPT_DIR}/..

DL=1
if [ "$1" == "--no-dl" ]
then
	DL=0
fi

if [ ${DL} -eq 1 ]
then
	rm -rf ${TOP_DIR}/dl/neon-beat-*
	make -C ${TOP_DIR} neon-beat-{{game,admin}-frontend,backend}-dirclean all
	make -C ${TOP_DIR} neon-beat-{{game,admin}-frontend,backend}
else
	make -C ${TOP_DIR} neon-beat-{{game,admin}-frontend,backend}-rebuild
fi
ssh nbc "systemctl stop neon-beat-backend"
scp -O ${TOP_DIR}/output/target/usr/bin/neon-beat-back nbc:/usr/bin
scp -rO ${TOP_DIR}/output/target/srv/www nbc:/srv
ssh nbc "systemctl start neon-beat-backend"
