class gameserver::host (
  $network_device    = $::gameserver::network_device,
  $ip_addr           = $::gameserver::ip_addr,
  $my_hostname       = $::gameserver::my_hostname,
  $my_domain         = $::gameserver::my_domain,
  $my_shortname      = $::gameserver::my_shortname,
  $netmask           = $::gameserver::netmask,
  $network           = $::gameserver::network,
) {
  ## host configuration
  file { '/etc/hosts':
    ensure => 'present',
    content => epp('gameserver/hosts.epp', {'ip_addr' => $ip_addr, 'hostname' => $my_hostname, 'shortname' => $my_shortname, 'domain' => $my_domain}),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
 
  file { "/etc/sysconfig/network-scripts/ifcfg-${network_device}":
    ensure => 'present',
    content => epp('gameserver/ifcfg-lan.epp', {'ip_addr' => $ip_addr, 'network_device' => $network_device, 'network' => $network, 'netmask' => $netmask}),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
 
  service { 'firewalld':
    ensure  => 'stopped',
    enable  => 'false',
  }
 
  ## disable_selinux. Reboot to make effect. Or run "setenforce 0" on command line as root.
  file_line { 'selinux_disable':
    ensure => 'present',
    path   => '/etc/selinux/config',
    line   => 'SELINUX=disabled',
    match  => '^SELINUX=',
  }

  file { "/usr/local/sbin/add_game.sh":
    ensure => 'present',
    source => 'puppet:///modules/gameserver/add_game.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/usr/local/sbin/recreate_whitelist.sh":
    ensure => 'present',
    source => 'puppet:///modules/gameserver/recreate_whitelist.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/usr/local/sbin/nat_control.sh":
    ensure => 'present',
    source => 'puppet:///modules/gameserver/nat_control.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
}
