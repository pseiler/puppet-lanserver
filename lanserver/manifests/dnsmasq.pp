class lanserver::dnsmasq (
  $ip_addr,
  $domain,
  $netmask,
  $network,
  $dhcp_start,
  $dhcp_end,

) {
  package { 'dnsmasq':
    ensure        => 'installed',
    allow_virtual => false,
  } 
  ### dnsmasq
  file { '/etc/dnsmasq.conf':
    ensure => 'present',
    content => epp('lanserver/dnsmasq.conf.epp', {'domain' => $domain, 'ip_addr' => $ip_addr, 'netmask' => $netmask, 'network' => $network, 'dhcp_start' => $dhcp_start, 'dhcp_end' => $dhcp_end,}),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Service['dnsmasq'],
  }
  
  service { 'dnsmasq':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/dnsmasq.conf'],],
  }
}
