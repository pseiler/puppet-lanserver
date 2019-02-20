# Class lanserver::ngircd
#
# This class installs and configures a local ngircd server to
# instanst messaging on the lan party. Especially usefull for
# bigger lan environments.
#

class lanserver::ngircd (
  $my_domain,
  $my_hostname,
  $ip_addr,
  $admin_user,
  $password,
) {
  package { 'ngircd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  file { '/etc/ngircd.conf':
    ensure => 'present',
    content => epp('lanserver/ngircd.conf.epp', {'ip_addr' => $ip_addr, 'domain' => $my_domain, 'hostname' => $my_hostname, 'operator' => $admin_user, 'operator_password' => $password,}),
    mode   => '0660',
    owner  => 'root',
    group  => 'ngircd',
    notify => [Service['ngircd'],Package['ngircd'],],
  }
  file { '/etc/ngircd.motd':
    ensure => 'present',
    source => "puppet:///modules/lanserver/ngircd.motd",
    mode   => '0660',
    owner  => 'root',
    group  => 'ngircd',
    notify => [Service['ngircd'],],
    require => [Package['ngircd'],],
  }
  
#     #configuration file
#     file { '/etc/ngircd/ngircd-ipv4.conf':
#       ensure => 'present',
#       source => "puppet:///modules/lanserver/ngircd-ipv4.conf",
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
