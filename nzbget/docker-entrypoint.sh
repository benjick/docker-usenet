#!/bin/sh
set -e
export TERM=linux

if ! [ -e /volumes/config/nzbget.conf ]; then
  echo >&2 "No config found - copying now..."
  cp /usr/share/nzbget/nzbget.conf /volumes/config/nzbget.conf
fi
ls -la /volumes/config
exec "$@"
