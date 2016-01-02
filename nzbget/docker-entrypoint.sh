#!/bin/sh
set -e
export TERM=linux
ls -la /usr/local/etc/
# /usr/share/nzbget/nzbget.conf <- default config
if ! [ -e /usr/local/etc/nzbget.conf ]; then
  echo >&2 "No config found - copying now..."
  cp /usr/share/nzbget/nzbget.conf /usr/local/etc/nzbget.conf
  ls /usr/local/etc
fi
exec "$@"
