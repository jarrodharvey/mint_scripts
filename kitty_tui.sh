#!/bin/bash

config_portable_location='/home/jarrod/Dropbox/.config_portable'
kitty --session $config_portable_location/kitty_startup_session.txt \
	--config $config_portable_location/kitty.conf \
	--override allow_remote_control=yes
