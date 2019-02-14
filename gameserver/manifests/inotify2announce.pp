class gameserver::inotify2announce (
  $admin_user,
  $password,
  $watchdir,
  $webroot,
  $torrent_dir,
  $tracker_url,
) {
 
  file { '/usr/local/bin/inotify2announce.sh':
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/inotify2announce.sh",
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/sysconfig/lan_server'],
    notify  => Service['inotify2announce'],
  }
  
  file { '/etc/systemd/system/inotify2announce.service':
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/inotify2announce.service",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => [File['/etc/sysconfig/lan_server'],],
    notify  => [Exec['systemd_reload'],Service['inotify2announce'],],
  }
  service { 'inotify2announce':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/systemd/system/inotify2announce.service'],],
  }
}
