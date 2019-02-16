#!/bin/bash
source /etc/sysconfig/lan_server;
rm /var/opentracker/whitelist;
touch /var/opentracker/whitelist;

for i in ${WEB_ROOT}/torrent/*.torrent;
do
    MY_HASH=$(transmission-show "${i}" | grep Hash | xargs | cut -d" " -f2);
    echo "$MY_HASH" >> /var/opentracker/whitelist;
done;

for i in ${WEB_ROOT}/upload/*.torrent;
do
    MY_HASH=$(transmission-show "${i}" | grep Hash | xargs | cut -d" " -f2);
    echo "$MY_HASH" >> /var/opentracker/whitelist;
done;
systemctl reload opentracker-ipv4.service;
