# Class lanserver::vsftpd
# 
# This class installs and configures the vsftpd FTP service.
# Following variables used:
# $ip_addr -> used to configure the listen address
# $anon_ftp_root -> changeroot directory for anonymous FTP uploads
#

class lanserver::vsftpd (
  $ip_addr,
  $anon_ftp_root,
  $vsftpd_conf_file = $::lanserver::params::vsftpd_conf_file,
) {
  package { 'vsftpd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  ## deploy configuration file
  file { $vsftpd_conf_file:
    ensure => 'present',
    content => epp('lanserver/vsftpd.conf.epp', {'ip_addr' => $ip_addr, 'anon_ftp_root' => $anon_ftp_root,}),
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
    notify => Service['vsftpd'],
  }
  
  service { 'vsftpd':
    ensure  => 'running',
    enable  => 'true',
    require => [File[$vsftpd_conf_file,'/var/ftp/upload'],],
  }

  file { $anon_ftp_root:
    ensure  => 'directory',
    mode    => '0550',
    owner   => 'root',
    group   => 'root',
    require => Package['vsftpd'],
  }
  
  ### anonymous upload dir
  ### Unfortunately vsftpd doesn't support uploads on the changeroot "/" directory.
  ### So a subdirectory must be created and used to upload files instead of "/" directory
  file { "${anon_ftp_root}/upload":
    ensure  => 'directory',
    mode    => '0750',
    owner   => 'ftp',
    group   => 'root',
    require => [File[$anon_ftp_root],Package['vsftpd'],],
  }
}
