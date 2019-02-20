#!/bin/bash
WATCH_DIR="${1}"
TORRENT_ROOT="${2}"
WEB_ROOT="${3}"
TRANSMISSION_USER="${4}"
TRANSMISSION_PASSWD="${5}"
TRACKER_URL="${6}"
ALTERNATE_URL="${7}"

if [ -z ${TORRENT_ROOT} ];
then
    TORRENT_ROOT="/var/lib/transmission/Downloads"
fi

if [ -z ${WEB_ROOT} ];
then
    WEB_ROOT="/var/www/html/upload"
fi

if [ -z ${TRACKER_URL} ];
then
    TRACKER_URL="http://server.lan:6969/announce"
fi

if [ -z ${WATCH_DIR} ];
then
    WATCH_DIR=$(pwd)
fi

### watch directory -> mv to torrent client dir -> create *.torrent file -> add torrent to client -> mv *.torrent file to webserver dir
inotifywait -mrq -e close_write --excludei '.*(\.part)' --format %f ${WATCH_DIR} | while read FILE
do
    mv "${WATCH_DIR}/${FILE}" "${TORRENT_ROOT}/"
    chown transmission:transmission "${TORRENT_ROOT}/${FILE}"
    transmission-create -t "$TRACKER_URL" -o "${TORRENT_ROOT}/${FILE}.torrent" "${TORRENT_ROOT}/${FILE}"
    if [ ! -z ${ALTERNATE_URL} ]
    then
        transmission-edit "${TORRENT_ROOT}/${FILE}.torrent" -a "${ALTERNATE_URL}"
    fi
    MY_HASH=$(transmission-show "${TORRENT_ROOT}/${FILE}.torrent" | grep Hash | xargs | cut -d" " -f2)
    echo "$MY_HASH" >> /var/opentracker/whitelist
    systemctl reload opentracker-ipv4.service
    transmission-remote "localhost:9091" --auth "${TRANSMISSION_USER}:${TRANSMISSION_PASSWD}" -a "${TORRENT_ROOT}/${FILE}.torrent"
    mv "${TORRENT_ROOT}/${FILE}.torrent" "${WEB_ROOT}/${FILE}.torrent"
    chown apache:apache "${WEB_ROOT}/${FILE}.torrent"
done
