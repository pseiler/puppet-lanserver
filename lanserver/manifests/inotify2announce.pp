# Class lanserver::inotify2announce
#
# This class deploys a self written bash "watchdog" which
# waits for file write finishes in the configured directory.
# Files in this directory will be moved to the torrent clients directory
# and a *.torrent will be made for it.
# This file will be added the torrent to the clients
# directory, and moved to the webserver in the /upload
# directory.
#
# The watchdog can controlled by systemd. the service name is
# "inotify2announce"

class lanserver::inotify2announce (
  $admin_user,
  $password,
  $watchdir,
  $webroot,
  $torrent_dir,
  $tracker_url,
) {
 
  file { '/usr/local/sbin/inotify2announce.sh':
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/inotify2announce.sh",
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/sysconfig/lan_server'],
    notify  => Service['inotify2announce'],
  }
  
  file { '/etc/systemd/system/inotify2announce.service':
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/inotify2announce.service",
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
