#!/bin/bash

if [ $UID -ne 0 ];
then
    echo "Script needs to be executed as root";
    exit 1;
fi

my_help() {
    echo "Valid parameters:";
    echo "$0 enable \"\$WAN_IF\"";
    echo "$0 disable";
}

enable_nat(){
    sysctl -w net.ipv4.ip_forward=1 > /dev/null;
    iptables -t nat -A POSTROUTING -o $IFACE_INET -j MASQUERADE;
    iptables -A FORWARD -i eth0 -o $IFACE_INET -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i $IFACE_INET -o eth0 -j ACCEPT   
#    iptables -A FORWARD -o $IFACE_INET -j ACCEPT;
}

disable_nat(){
    sysctl -w net.ipv4.ip_forward=0 > /dev/null;
    iptables -F;
    iptables -t nat -F;
}

case "$1" in
    enable)
        if [ -z "$2" ];
        then
            echo "No interface parameter set";
            echo "";
            my_help;
            exit 1;
        fi
        IFACE_INET=$2;
        enable_nat
#        echo "dhcp-option=option:router,10.20.0.1" > /etc/dnsmasq.d/gateway
#        echo "server=46.38.235.212" >> /etc/dnsmasq.d/gateway
#        systemctl restart dnsmasq.service
        ;;
    disable)
        disable_nat
#        echo "dhcp-option=option:router" > /etc/dnsmasq.d/gateway
#        systemctl restart dnsmasq.service
        ;;
    *)
        echo "No enable|disable parameter used.";
        echo "";
        my_help;
        ;;
esac

exit 0
