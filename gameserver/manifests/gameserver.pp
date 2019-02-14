class gameserver::gameserver (
) {
  package { ['glibc.i686','libgcc.i686']:
    ensure        => 'installed',
    allow_virtual => false,
  }

  user { 'gameserver':
    ensure     => 'present',
    home       => '/home/gameserver',
    password   => 'winterlan',
    shell      => '/bin/bash',
    uid        => '1110',
    gid        => '1110',
    comment    => 'gameserver user',
    managehome => true,
  }
  group { 'gameserver':
    ensure => 'present',
    gid    => '1110',
  }

#  #configuration file
#  file { '/home/kiwi/kiwiirc/config.js':
#    ensure  => 'present',
#    source  => "puppet:///modules/gameserver/kiwiirc.js",
#    mode    => '0644',
#    owner   => 'kiwi',
#    group   => 'kiwi',
#    notify  => [Exec['start_kiwi'],],
#    require => [User['kiwi'],Group['kiwi'],],
#  }
  
#  file { '/home/kiwi/kiwiirc/KiwiIRC.tar.gz':
#    ensure  => 'present',
#    source  => "puppet:///modules/gameserver/KiwiIRC-v${kiwi_version}.tar.gz",
#    mode    => '0644',
#    owner   => 'kiwi',
#    group   => 'kiwi',
#    require => [User['kiwi'],Group['kiwi'],],
#  }
#  file { '/home/kiwi/deploy_kiwi.sh':
#    ensure  => 'present',
#    source  => "puppet:///modules/gameserver/deploy_kiwi.sh",
#    mode    => '0755',
#    owner   => 'kiwi',
#    group   => 'kiwi',
#    require => [User['kiwi'],Group['kiwi'],File['/home/kiwi/kiwiirc/KiwiIRC.tar.gz','/home/kiwi/kiwiirc/config.js'],],
#  }
#  exec { 'start_kiwi':
#    path        => ['/sbin','/usr/sbin','/bin','/usr/bin','/usr/local/bin','/usr/local/sbin','/home/kiwi/bin'],
#    command     => '/home/kiwi/deploy_kiwi.sh',
#    user        => 'kiwi',
#    group       => 'kiwi',
#    refreshonly => 'true',
#  }
}
