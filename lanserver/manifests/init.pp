# 

class lanserver (
$enable_hostconfiguration      = true,
$enable_dnsmasq                = true,
$enable_vsftpd                 = true,
$enable_transmission           = true,
$enable_inotify2announce       = true,
$enable_opentracker            = true,
$enable_httpd                  = true,
$enable_webroot                = true,
$enable_ngircd                 = true,
$enable_kiwiirc                = true,
$enable_gameserver             = false,
$webroot                       = '/var/www/html',
$admin_user                    = 'admin',
$password                      = 'lanparty',
$server_ip                     = '10.20.0.1',
$network                       = '10.20.0.0',
$dhcp_start                    = '10.20.0.100',
$dhcp_end                      = '10.20.0.200',
$netmask                       = '255.255.255.0',
$network_device                = 'eth1',
$my_hostname                   = 'server',
$my_shortname                  = 'srv',
$my_domain                     = 'lan',
Integer $transmission_rpc_port = 9091,
$anon_ftp_root                 = '/var/ftp',
$torrent_dir                   = '/var/lib/transmission/Downloads',
$transmission_whitelist_ips    = '10.0.0.1, 10.0.0.2',
$tracker_rootdir               = '/var/opentracker',
$tracker_port                  = 6969,
$template_dir                  = '/var/www/template',
$tracker_url                   = "http://${my_hostname}.${my_domain}:${tracker_port}/announce",

) {
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
