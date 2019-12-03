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
  $opentracker_package_name = $::lanserver::params::opentracker_package_name,
  $opentracker_conf         = $::lanserver::params::opentracker_conf,
  $opentracker_bin          = $::lanserver::params::opentracker_bin,
) {
  package { $opentracker_package_name:
    ensure        => 'installed',
    allow_virtual => false,
  }
  file { '/etc/systemd/system/opentracker-ipv4.service':
    ensure => 'present',
    content => epp('lanserver/opentracker-ipv4.service.epp', {'opentracker_conf' => $opentracker_conf, 'opentracker_bin' => $opentracker_bin,}),
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Exec['systemd_reload'],
  }
  
  #configuration file
  file { $opentracker_conf:
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
    require => [File[$opentracker_conf,'/etc/systemd/system/opentracker-ipv4.service'],],
  } 
}
