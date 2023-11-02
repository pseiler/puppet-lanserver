class lanserver::host (
  $network_device    		   = $::lanserver::network_device,
  $ip_addr           		   = $::lanserver::ip_addr,
  $my_hostname       		   = $::lanserver::my_hostname,
  $my_domain         		   = $::lanserver::my_domain,
  $my_shortname      		   = $::lanserver::my_shortname,
  $netmask           		   = $::lanserver::netmask,
  $network           		   = $::lanserver::network,
  Enum['static','none'] $bootproto = $::lanserver::bootproto,
  $network_scripts   		   = $::lanserver::network_scripts,
) {
  ## host configuration
  file { '/etc/hosts':
    ensure => 'present',
    content => epp('lanserver/hosts.epp', {
      'ip_addr'   => $ip_addr,
      'hostname'  => $my_hostname,
      'shortname' => $my_shortname,
      'domain'    => $my_domain,
    }),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
 
  if ($facts['os']['family'] == 'Suse') {
    $startmode = 'ifplugd'
  } else {
    $startmode = undef
  }
  file { "${network_scripts}/ifcfg-${network_device}":
    ensure => 'present',
    content => epp('lanserver/ifcfg-lan.epp', {
      'ip_addr'        => $ip_addr,
      'network_device' => $network_device,
      'network'        => $network,
      'netmask'        => $netmask,
      'bootproto'      => $bootproto,
      'startmode'      => $startmode,
    }),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
 
  service { 'firewalld':
    ensure  => 'stopped',
    enable  => 'false',
  }
  if ($facts['os']['family'] == 'Redhat') {
    ## disable_selinux. Reboot to make effect. Or run "setenforce 0" on command line as root.
    file_line { 'selinux_disable':
      ensure => 'present',
      path   => '/etc/selinux/config',
      line   => 'SELINUX=disabled',
      match  => '^SELINUX=',
    }
  }
  # nmcli con add con-name lan0 type ethernet ifname enp7s0 ipv4.method manual ipv4.address 10.20.0.1/24

  file { "/usr/local/sbin/recreate_whitelist.sh":
    ensure => 'present',
    source => 'puppet:///modules/lanserver/recreate_whitelist.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { "/usr/local/sbin/nat_control.sh":
    ensure => 'present',
    source => 'puppet:///modules/lanserver/nat_control.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
  file { "/usr/local/sbin/lanserver":
    ensure => 'present',
    source => 'puppet:///modules/lanserver/lanserver.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
}
