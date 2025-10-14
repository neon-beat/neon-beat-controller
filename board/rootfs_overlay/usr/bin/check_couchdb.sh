#!/bin/sh

docker image inspect arm64v8/couchdb:3.4 > /dev/null 2>&1
if [ $? -eq 0 ]
then
	return 1
fi

return 0
