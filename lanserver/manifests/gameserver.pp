class lanserver::gameserver (
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
}
