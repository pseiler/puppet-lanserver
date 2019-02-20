#!/bin/bash
ERROR=0

SERVICES=("opentracker-ipv4" "transmission-daemon" "dnsmasq" "httpd" "vsftpd" "ngircd" "inotify2announce");

check_root() {
if [ $UID -ne 0 ];
then        
    echo "This script needs to be run as root";
    exit 1;
fi
}

case "${1}" in
    start)
        check_root
        echo "Starting services:";
        systemctl start ${SERVICES[@]};
        echo "${SERVICES[@]}";
        ;;
    stop)
        check_root
        echo "Stopping services:";
        echo "${SERVICES[@]}";
        systemctl stop ${SERVICES[@]};
        ;;
    status)
        echo "Service Status:";
        for i in ${SERVICES[@]}
        do
            if systemctl is-active "${i}" > /dev/null;
            then
                echo -e "\"${i}\" is \e[32mrunning\e[39m.";
            else
                echo -e "\"${i}\" is \e[31mnot running\e[39m."
                ERROR=1
            fi;
        done;
        ;;
    *)
        echo "Not a supported command. The following are supported:";
        echo "$0 start|stop|status";
        ;;
esac

if [ $ERROR -ne 0 ];
then
    exit 1;
fi;
