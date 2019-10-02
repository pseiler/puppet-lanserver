class lanserver::kiwiirc (
  $kiwi_version = "0.9.4",
) {
  package { 'npm':
    ensure        => 'installed',
    allow_virtual => false,
  }

  user { 'kiwi':
    ensure     => 'present',
    home       => '/home/kiwi',
    password   => 'kiwi',
    shell      => '/bin/bash',
    uid        => '1100',
    gid        => '1100',
    comment    => 'kiwiirc user',
    managehome => true,
  }
  group { 'kiwi':
    ensure => 'present',
    gid    => '1100',
  }

  file { '/home/kiwi/kiwiirc':
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'kiwi',
    group   => 'kiwi',
    require => [User['kiwi'],Group['kiwi'],],
  }
  #configuration file
  file { '/home/kiwi/kiwiirc/config.js':
    ensure  => 'present',
    source  => 'puppet:///modules/lanserver/kiwiirc.js',
    mode    => '0644',
    owner   => 'kiwi',
    group   => 'kiwi',
    notify  => [Exec['start_kiwi'],],
    require => [User['kiwi'],Group['kiwi'],],
  }

  file { '/home/kiwi/kiwiirc/KiwiIRC.tar.gz':
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/KiwiIRC-v${kiwi_version}.tar.gz",
    mode    => '0644',
    owner   => 'kiwi',
    group   => 'kiwi',
    require => [User['kiwi'],Group['kiwi'],],
  }
  file { '/home/kiwi/deploy_kiwi.sh':
    ensure  => 'present',
    source  => 'puppet:///modules/lanserver/deploy_kiwi.sh',
    mode    => '0755',
    owner   => 'kiwi',
    group   => 'kiwi',
    require => [User['kiwi'],Group['kiwi'],File['/home/kiwi/kiwiirc/KiwiIRC.tar.gz','/home/kiwi/kiwiirc/config.js'],],
  }
  exec { 'start_kiwi':
    path        => ['/sbin','/usr/sbin','/bin','/usr/bin','/usr/local/bin','/usr/local/sbin','/home/kiwi/bin'],
    command     => '/home/kiwi/deploy_kiwi.sh',
    user        => 'kiwi',
    group       => 'kiwi',
    refreshonly => true,
  }
}
