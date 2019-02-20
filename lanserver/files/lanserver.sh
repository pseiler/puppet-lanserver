#!/bin/bash

SERVICES=("opentracker-ipv4", "transmission-daemon", "dnsmasq", "httpd", "vsftpd", "ngircd" "inotify2announce");

case "${1}" in
    start)
        echo "Starting services:";
        ;;
    stop)
        echo "Stopping services:";
        ;;
    status)
        echo "Service Status:";
        systemctl status ${SERVICES[@]};
        ;;
    *)
        echo "Not a supported command. The following are supported:";
        echo "$0 start|stop|status";
        ;;
esac

