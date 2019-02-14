## apache
### prevent welcome bage to load if apache is freshly installed
class gameserver::httpd (
) {
  package { 'httpd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  file { '/etc/httpd/conf.d/welcome.conf':
    ensure => 'absent',
    notify => Service['httpd'],
  }
  
  service { 'httpd':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/httpd/conf.d/welcome.conf'],],
  }
  
  file { '/etc/httpd/conf/httpd.conf':
    ensure  => 'present',
    source  => 'puppet:///modules/gameserver/httpd.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['httpd'],
  }
  
  file_line { 'disable_detailed_directory_listing':
    ensure => 'present',
    path   => '/etc/httpd/conf.d/autoindex.conf',
    line   => 'IndexOptions VersionSort',
    match  => '^IndexOptions',
    notify => [Service['httpd'],],
  }
}
