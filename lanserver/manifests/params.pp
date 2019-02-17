# Class lanserver::params
#
# This class manages the parameters used in all other components
#
# Parameters:
# - enable_hostconfiguration:  enables the configuration of the base operation system
#                              such like disabling the firewalld, configuring /etc/hosts
#                              and /etc/sysyconfig/network-scripts/ifcfg files. Also
#                              installs the scripts to enable NAT routing for example
#
# - enable_dnsmasq:            enables the installation and configuration of the DNS
#                              and DHCP server. Gets it's configuration values from other
#                              parameters like $ip_addr.
#
# - enable_vsftpd:             enables the installation and configuration of the FTP server
#
# - enable_transmission:       enables the installation and configuration of the torrent
#                              client
#
# - enable_inotify2announce:   enables the installation and configuration of the
#                              inotify2announce component which combines the FTP Server, the
#                              torrent client and the torrent tracker.
#
# - enbale_opentracker:        enables the installation and configuration of the BitTorrent
#                              tracker including whitelisting and customized systemd service
#                              file to enable reloading the daemon
#
# - enable_httpd:              enables the installation and configuration of the apache2 httpd
#                              webserver including configuration for directory listing
#
# - enable_webroot:            installs several *.html documents for the webserver
# 
# - enable_ngircd:             enables the installation and configuration of the ngicrd IRC
#                              server. 
# 
# - enable_kiwiirc:            enables the installation and configuration of the kiwiirc IRC
#                              web client. Needs internet acces for deployment as it install
#                              nodejs requirements
#
# - enable_gameserver:         enables the user for gameserver. WIP (maybe this will be removed
#                              in the future.
#
# - webroot:                   directory for the documentroot used by the webserver. Value is used by
#                              the webroot and inotify2announce class to deploy the files at the
#                              correct place.
#                              Default:
#                               * SLES: "/srv/www/html"
#                               * others: "/var/www/html"
#
# - admin_user:                user account which is set for all services requiring a login.
# 
# - password:                  the coressponding password for the admin account
#
# - server_ip:                 the IP addres where every component is setting it's listening address.
#                              also the indicator for the class host for
#                              /etc/sysconfig/network-scripts/ifcfg-${network_device}
#                              Default: 10.20.0.1
#
# - network:                   The network adress for ifcfg-${network_device} and the dhe DHCP Server Dnsmasq. 
#                              Default: 10.20.0.0
#
# - dhcp_start:                The first address of the IP range served by the DHCP Server.
#                              Default: 10.20.0.100
#
# - dhcp_end:                  the last address of the IP range served by the DHCP Server.
#                              Default: 10.20.0.200
#
# - netmask:                   the subnet mask for the interface and DHCP configuration.
#                              Default: 255.255.255.0
# 
# - network_device:            The ethernet device used to configurate all services.
#                              Default: eth0
#
# - my_hostname:               The hostname of the server. Affects a lot of configurations
#                              Default: server
#
# - my_shortname:              An hostname alias of the server. Usually a shorter name
#                              Default: srv
#
# - my_domain:                 The domain for the network. Relevant for the /etc/hosts entry
#                              and for DNS of Dnsmasq. Affects a lot of configurations.
#                              Default: lan
# 
# - transmission_rpc_port:     The port for the RPC / Webserver of transmission.
#                              Default: 9091
# 
#
# - transmission_whitelist_ips:
# 
# - anon_ftp_root
#
# - torrent_dir
#
# - tracker_rootdir
#
# - tracker_port
#
# - template_dir
#
# - tracker_url

class lanserver::params {
$enable_hostconfiguration      = true
$enable_dnsmasq                = true
$enable_vsftpd                 = true
$enable_transmission           = true
$enable_inotify2announce       = true
$enable_opentracker            = true
$enable_httpd                  = true
$enable_webroot                = true
$enable_ngircd                 = true
$enable_kiwiirc                = true
$enable_gameserver             = false

if ($::operatingsystem == 'SLES') {
    $webroot                       = '/srv/www/html'
} else {
    $webroot                       = '/var/www/html'
}
$admin_user                    = 'admin'
$password                      = 'lanparty'
$server_ip                     = '10.20.0.1'
$network                       = '10.20.0.0'
$dhcp_start                    = '10.20.0.100'
$dhcp_end                      = '10.20.0.200'
$netmask                       = '255.255.255.0'
$network_device                = 'eth1'
$my_hostname                   = 'server'
$my_shortname                  = 'srv'
$my_domain                     = 'lan'
$transmission_rpc_port         = 9091
$transmission_whitelist_ips    = '10.0.0.1, 10.0.0.2'
$torrent_dir                   = '/var/lib/transmission/Downloads'
$anon_ftp_root                 = '/var/ftp'
$tracker_rootdir               = '/var/opentracker'
$tracker_port                  = 6969
$tracker_url                   = "http://${my_hostname}.${my_domain}:${tracker_port}/announce"
$template_dir                  = '/var/www/template'
}
