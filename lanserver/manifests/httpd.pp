# Class lanserver::httpd
#
# This class installs and configures the apache webserver on work for the
# lanserver environment
#

## apache
class lanserver::httpd (
  $apache_package_name = $::lanserver::params::apache_package_name,
  $apache_service_name = $::lanserver::params::apache_service_name,
  $apache_conf_file    = $::lanserver::params::apache_conf_file,
) {
  package { $apache_package_name:
    ensure        => 'installed',
    allow_virtual => false,
  }
  ### prevent welcome bage to load if apache is freshly installed
  file { '/etc/httpd/conf.d/welcome.conf':
    ensure => 'absent',
    notify => Service[$apache_service_name],
  }
 
  # ensure apache is running 
  service { $apache_service_name:
    ensure  => 'running',
    enable  => 'true',
    require => [File['/etc/httpd/conf.d/welcome.conf'],],
  }
  
  # deploy configuration file.
  file { $apache_conf_file:
    ensure  => 'present',
    source  => 'puppet:///modules/lanserver/httpd.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$apache_package_name],
  }
  
  # make output of file listing simpler 
  file_line { 'disable_detailed_directory_listing':
    ensure => 'present',
    path   => '/etc/httpd/conf.d/autoindex.conf',
    line   => 'IndexOptions VersionSort',
    match  => '^IndexOptions',
    notify => [Service[$apache_package_name],],
  }
}
