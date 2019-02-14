class gameserver::vsftpd (
  $ip_addr,
  $anon_ftp_root,
) {
  package { 'vsftpd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  ## vsftp
  file { '/etc/vsftpd/vsftpd.conf':
    ensure => 'present',
    content => epp('gameserver/vsftpd.conf.epp', {'ip_addr' => $ip_addr, 'anon_ftp_root' => $anon_ftp_root,}),
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
    notify => Service['vsftpd'],
  }
  
  service { 'vsftpd':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/vsftpd/vsftpd.conf','/var/ftp/upload'],],
  }
  
  ### anonymous upload dir
  file { "${anon_ftp_root}/upload":
    ensure  => 'directory',
    mode    => '0750',
    owner   => 'ftp',
    group   => 'root',
  #  notify  => Service['opentracker-ipv4'],
    require => Package['vsftpd'],
  }
}
