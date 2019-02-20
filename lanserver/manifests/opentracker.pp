# Class lanserver::opentracker
#
# This class installs the opentracker BiTorrent
# tracker software including a config file to
# the system.
#


class lanserver::opentracker (
  $ip_addr,
  $tracker_rootdir,
  $tracker_port,
) {
  package { 'opentracker-ipv4':
    ensure        => 'installed',
    allow_virtual => false,
  }
  file { '/etc/systemd/system/opentracker-ipv4.service':
    ensure => 'present',
    source => "puppet:///modules/lanserver/opentracker-ipv4.service",
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Exec['systemd_reload'],
  }
  
  #configuration file
  file { '/etc/opentracker/opentracker-ipv4.conf':
    ensure => 'present',
    content => epp('lanserver/opentracker-ipv4.conf.epp', {'ip_addr' => $ip_addr, 'tracker_port' => $tracker_port, 'tracker_rootdir' => $tracker_rootdir,}),

    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => [Service['opentracker-ipv4'],],
  }
  service { 'opentracker-ipv4':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/opentracker/opentracker-ipv4.conf','/etc/systemd/system/opentracker-ipv4.service'],],
  } 
}
