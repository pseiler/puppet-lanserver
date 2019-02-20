# Class lanserver::httpd
#
# This class installs and configures the apache webserver on work for the
# lanserver environment
#

## apache
class lanserver::httpd (
) {
  package { 'httpd':
    ensure        => 'installed',
    allow_virtual => false,
  }
  ### prevent welcome bage to load if apache is freshly installed
  file { '/etc/httpd/conf.d/welcome.conf':
    ensure => 'absent',
    notify => Service['httpd'],
  }
 
  # ensure apache is running 
  service { 'httpd':
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/httpd/conf.d/welcome.conf'],],
  }
  
  # deploy configuration file.
  file { '/etc/httpd/conf/httpd.conf':
    ensure  => 'present',
    source  => 'puppet:///modules/lanserver/httpd.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['httpd'],
  }
  
  # make output of file listing simpler 
  file_line { 'disable_detailed_directory_listing':
    ensure => 'present',
    path   => '/etc/httpd/conf.d/autoindex.conf',
    line   => 'IndexOptions VersionSort',
    match  => '^IndexOptions',
    notify => [Service['httpd'],],
  }
}
