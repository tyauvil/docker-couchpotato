#!/bin/dumb-init /bin/sh
set -e

if test $( id "${USERNAME}" -u ) != "${PUID}" ||
   test $( id "${USERNAME}" -g ) != "${PGID}" ]; then
  deluser "${USERNAME}"
  delgroup "${USERNAME}"
fi

if [ ! $( id -u "${USERNAME}" ) ]; then
  addgroup -S -g "${PGID}" "${USERNAME}"
  adduser -S "${USERNAME}" -G "${USERNAME}" -u "${PUID}"
fi

chown -R "${USERNAME}": /opt /config

su-exec "${USERNAME}" /usr/bin/python /opt/couchpotato/CouchPotato.py --config_file="${CONFIG_FILE}" --data_dir="${DATADIR}" --console_log
