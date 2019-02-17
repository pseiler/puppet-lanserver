# 

class lanserver (
$enable_hostconfiguration      = $::lanserver::params::enable_hostconfiguration,
$enable_dnsmasq                = $::lanserver::params::enable_dnsmasq,
$enable_vsftpd                 = $::lanserver::params::enable_vsftpd,
$enable_transmission           = $::lanserver::params::enable_transmission,
$enable_inotify2announce       = $::lanserver::params::enable_kiwiirc,
$enable_opentracker            = $::lanserver::params::enable_opentracker,
$enable_httpd                  = $::lanserver::params::enable_httpd,
$enable_webroot                = $::lanserver::params::enable_webroot,
$enable_ngircd                 = $::lanserver::params::enable_ngircd,
$enable_kiwiirc                = $::lanserver::params::enable_kiwiirc,
$enable_gameserver             = $::lanserver::params::enable_gameserver,
$webroot                       = $::lanserver::params::webroot,
$admin_user                    = $::lanserver::params::admin_user,
$password                      = $::lanserver::params::password,
$server_ip                     = $::lanserver::params::server_ip,
$network                       = $::lanserver::params::network,
$dhcp_start                    = $::lanserver::params::dhcp_start,
$dhcp_end                      = $::lanserver::params::dhcp_end,
$netmask                       = $::lanserver::params::netmask,
$network_device                = $::lanserver::params::network_device,
$my_hostname                   = $::lanserver::params::my_hostname,
$my_shortname                  = $::lanserver::params::my_shortname,
$my_domain                     = $::lanserver::params::my_domain,
Integer $transmission_rpc_port = $::lanserver::params::transmission_rpc_port,
$transmission_whitelist_ips    = $::lanserver::params::transmission_whitelist_ips,
$anon_ftp_root                 = $::lanserver::params::anon_ftp_root,
$torrent_dir                   = $::lanserver::params::torrent_dir,
$tracker_rootdir               = $::lanserver::params::tracker_rootdir,
$tracker_port                  = $::lanserver::params::tracker_port,
$template_dir                  = $::lanserver::params::template_dir,
$tracker_url                   = $::lanserver::params::tracker_url,
) inherits ::lanserver::params {
  ### packages to be installed
  package { ['net-tools','bind-utils','mktorrent','inotify-tools','git','wget']:
    ensure        => 'installed',
    allow_virtual => false,
  }
  ## refresh systemd when new opentracker or inotify2announce service is placed
  exec { 'systemd_reload':
    command     => '/usr/bin/systemctl daemon-reload',
#    subscribe   => File['/etc/systemd/system/opentracker-ipv4.service','/etc/systemd/system/inotify2announce.service'],
    refreshonly => true,
  }
  # setting variables for bash scripts
  file { '/etc/sysconfig/lan_server':
    ensure => 'present',
    content => epp('lanserver/lan_server.conf.epp', {'admin_user' => $admin_user, 'password' => $password, 'watchdir' => "${anon_ftp_root}/upload", 'webroot' => $webroot, 'tracker_url' => $tracker_url, 'torrent_dir' => $torrent_dir, 'template_dir' => $template_dir, 'port' => $transmission_rpc_port, 'fqdn' => "${my_hostname}.${my_domain}",}),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  
  ##################
  #### SERVICES ####
  ##################
  
  if $enable_hostconfiguration == true {
    class { '::lanserver::host':
      network_device => $network_device,
      ip_addr        => $server_ip,
      my_hostname    => $my_hostname,
      my_shortname   => $my_shortname,
      netmask        => $netmask,
      network        => $network,
    }
  }
  
  if $enable_dnsmasq == true {
    class { '::lanserver::dnsmasq':
      ip_addr    => $server_ip,
      domain     => $my_domain,
      netmask    => $netmask,
      network    => $network,
      dhcp_start => $dhcp_start,
      dhcp_end   => $dhcp_end,
    }
  }
  
  if $enable_vsftpd == true {
    class { '::lanserver::vsftpd':
      anon_ftp_root => $anon_ftp_root,
      ip_addr       => $server_ip,
    }
  }
  
  if $enable_transmission == true {
    class { '::lanserver::transmission':
      admin_user  => $admin_user,
      password    => $password,
      ip_addr     => $server_ip,
      rpc_port    => $transmission_rpc_port,
      whitelist   => $transmission_whitelist_ips,
      torrent_dir => $torrent_dir,
    }
  }
  
  if $enable_opentracker == true {
    class { '::lanserver::opentracker':
      ip_addr         => $server_ip,
      tracker_rootdir => $tracker_rootdir,
      tracker_port    => $tracker_port,
    }
  }
 
  if $enable_inotify2announce == true {
    class { '::lanserver::inotify2announce':
      admin_user    => $admin_user,
      password      => $password,
      watchdir      => "${anon_ftp_root}/upload",
      torrent_dir   => $torrent_dir,
      webroot       => $webroot,
      tracker_url   => $tracker_url,
    }
  }
  
  if $enable_httpd == true {
    class { '::lanserver::httpd':
    }
  }
  
  if $enable_webroot == true {
    class { '::lanserver::webroot':
      webroot      => $webroot,
      my_hostname  => $my_hostname,
      my_domain    => $my_domain,
      template_dir => $template_dir,
    }
  }

  if $enable_kiwiirc == true {
    class { '::lanserver::kiwiirc':
    }
  }

  if $enable_ngircd == true {
    class { '::lanserver::ngircd':
      ip_addr     => $server_ip,
      my_hostname => $my_hostname,
      my_domain   => $my_domain,
      admin_user  => $admin_user,
      password    => $password,
    }
  }

  if $enable_gameserver == true {
    class { '::lanserver::gameserver':
    }
  }

}
