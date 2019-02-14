class gameserver::ngircd (
) {
  package { 'ngircd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  file { '/etc/ngircd.conf':
    ensure => 'present',
    source => "puppet:///modules/gameserver/ngircd.conf",
    mode   => '0660',
    owner  => 'root',
    group  => 'ngircd',
    notify => [Service['ngircd'],Package['ngircd'],],
  }
  file { '/etc/ngircd.motd':
    ensure => 'present',
    source => "puppet:///modules/gameserver/ngircd.motd",
    mode   => '0660',
    owner  => 'root',
    group  => 'ngircd',
    notify => [Service['ngircd'],],
    require => [Package['ngircd'],],
  }
  
#     #configuration file
#     file { '/etc/ngircd/ngircd-ipv4.conf':
#       ensure => 'present',
#       source => "puppet:///modules/gameserver/ngircd-ipv4.conf",
#       mode   => '0644',
#       owner  => 'root',
#       group  => 'root',
#     }
  service { 'ngircd':
    ensure  => 'running',
    enable  => 'true',
    require => [Package['ngircd'],File['/etc/ngircd.motd','/etc/ngircd.conf'],],
  } 
}
