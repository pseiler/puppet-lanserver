# Class lanserver::webroot
#
# This class deploys the several html files to run the website for the lan party
#

class lanserver::webroot (
  $webroot,
  $my_domain,
  $my_hostname,
  $template_dir,
) {
  ## directory where the supported games are located
  file { "${webroot}/torrent":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  ### header file for directory listing
  file { "${webroot}/header.html":
    ensure  => 'present',
    content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Files',}),
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  ### index.html
  file { "${webroot}/index.html":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/index.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/technik.html":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/technik.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/torrent.html":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/torrent.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  ## stylesheet
  file { "${webroot}/stylesheet.css":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/stylesheet.css",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  ## image directory and images
  file { "${webroot}/images":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  file { "${webroot}/images/banner.png":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/images/logo.png",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/images/favicon.ico":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/images/favicon.ico",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
 ## required directories and files to create the template structure for supported games required by add_game.sh
 ## add_game.sh should probably be here instead of host.pp
  file { $template_dir:
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${template_dir}/howto":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${template_dir}/header.html":
    ensure  => 'present',
   content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Games',}),
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${template_dir}/footer.html":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/footer.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  

###########################################
# Generic tools needed to run a lan party #
###########################################

  ## create the tools directory for the website  
  file { "${webroot}/tools":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  file { "${webroot}/tools/7z1805.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/7z1805.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/7z1805-x64.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/7z1805.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/FileZilla_3.33.0_win32-setup_bundled.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/FileZilla_3.33.0_win32-setup_bundled.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/FileZilla_3.33.0_win64-setup_bundled.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/FileZilla_3.33.0_win64-setup_bundled.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/transmission-2.94-x64.msi":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/transmission-2.94-x64.msi",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/transmission-2.94-x86.msi":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/transmission-2.94-x86.msi",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/tools/HexChat_2.14.1_x86.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/HexChat_2.14.1_x86.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/tools/HexChat_2.14.1_x64.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/HexChat_2.14.1_x64.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/tools/WinCDEmu-4.1.exe":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/tools/WinCDEmu-4.1.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  ### howtos (will be deleted in the future. Setup specific
  file { "${webroot}/howto":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }

  file { "${webroot}/howto/Counter.Strike.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Counter.Strike.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Day.of.Defeat.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Day.of.Defeat.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Half.Life.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Half.Life.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Quake3.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Quake3.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/FlatOut2.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/FlatOut2.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/UT.2004.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/UT.2004.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Insurgency.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Insurgency.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Day.of.Infamy.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Day.of.Infamy.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Screencheat.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Screencheat.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Sven.Co-op.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Sven.Co-op.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Warcraft3.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/Warcraft3.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/The.Ship.Remasted.txt":
    ensure  => 'present',
    source  => "puppet:///modules/lanserver/webroot/howto/The.Ship.Remasted.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
}
