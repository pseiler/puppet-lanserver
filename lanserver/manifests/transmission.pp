class lanserver::transmission (
  String $admin_user,
  String $password,
  String $whitelist,
  String $ip_addr,
  String $torrent_dir,
  Integer $rpc_port,
  
) {
  package { ['transmission-daemon','transmission-common']:
    ensure        => 'installed',
    allow_virtual => false,
  }
  ## transmission
  exec { 'create_transmission_daemon_config':
    command => 'mkdir -p /var/lib/transmission/.config/transmission-daemon',
    require => Package['transmission-daemon'],
    path    => ['/sbin/', '/usr/sbin', '/bin/', '/usr/bin', '/usr/local/bin', '/usr/local/sbin'],
    unless  => 'test -d /var/lib/transmission/.config/transmission-daemon',
  }
  
  ### directory for the sharing torrent content
  file { '/var/lib/transmission/Downloads':
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'transmission',
    group   => 'transmission',
    require => Package['transmission-daemon'],
  }
  
  # configuration directory
  file { '/var/lib/transmission/.config':
    ensure  => 'present',
    mode    => '0755',
    owner   => 'transmission',
    group   => 'transmission',
    require => Exec['create_transmission_daemon_config'],
  }
  
  # configuration directory
  file { '/var/lib/transmission/.config/transmission-daemon':
    ensure  => 'present',
    mode    => '0755',
    owner   => 'transmission',
    group   => 'transmission',
    require => File['/var/lib/transmission/.config'],
  }
  
  # transmission configuration file
  file { '/var/lib/transmission/.config/transmission-daemon/settings.json':
    ensure  => 'present',
    content => epp('lanserver/transmission.json.epp', {'username' => $admin_user, 'password' => $password, 'whitelist' => $whitelist, 'enable_whitelist' => false, 'ip_addr' => $ip_addr, 'rpc_port' => $rpc_port, 'download_dir' => $torrent_dir}),
    mode    => '0600',
    owner   => 'transmission',
    group   => 'transmission',
#    notify  => Service['transmission-daemon'],
    require => [Package['transmission-daemon'], File['/var/lib/transmission/.config/transmission-daemon'],],
  }
  
#  service { 'transmission-daemon':
#    ensure  => 'running',
#    enable  => 'true',
#    require => [File['/var/lib/transmission/.config/transmission-daemon/settings.json'],],
#  }
}
