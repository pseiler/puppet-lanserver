# 

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
$webroot                       = '/var/www/html'
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
Integer $transmission_rpc_port = 9091
$transmission_whitelist_ips    = '10.0.0.1, 10.0.0.2'
$anon_ftp_root                 = '/var/ftp'
$torrent_dir                   = '/var/lib/transmission/Downloads'
$tracker_rootdir               = '/var/opentracker'
Integer $tracker_port          = 6969
$template_dir                  = '/var/www/template'
$tracker_url                   = "http://${my_hostname}.${my_domain}:${tracker_port}/announce"
}
