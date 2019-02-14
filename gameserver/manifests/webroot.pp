## deploying webroot
class gameserver::webroot (
  $webroot,
  $my_domain,
  $my_hostname,
  $template_dir,
) {
  # supported game directory
  file { "${webroot}/torrent":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  ### html files
  file { "${webroot}/header.html":
    ensure  => 'present',
    content => epp('gameserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Files',}),
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/index.html":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/index.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
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
   content => epp('gameserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Games',}),
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${template_dir}/footer.html":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/footer.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/technik.html":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/technik.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/torrent.html":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/torrent.html",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  ### www stylesheet
  file { "${webroot}/stylesheet.css":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/stylesheet.css",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  
  ## images
  file { "${webroot}/images":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  file { "${webroot}/images/banner.png":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/images/logo.png",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/images/favicon.ico":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/images/favicon.ico",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  ### how tos
  file { "${webroot}/howto":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }

  file { "${webroot}/howto/Counter.Strike.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Counter.Strike.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Day.of.Defeat.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Day.of.Defeat.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Half.Life.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Half.Life.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Quake3.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Quake3.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/FlatOut2.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/FlatOut2.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/UT.2004.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/UT.2004.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Insurgency.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Insurgency.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Day.of.Infamy.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Day.of.Infamy.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Screencheat.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Screencheat.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Sven.Co-op.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Sven.Co-op.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/Warcraft3.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/Warcraft3.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/howto/The.Ship.Remasted.txt":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/howto/The.Ship.Remasted.txt",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

#####
#####
 
  ### deploy every neccessary tool
  file { "${webroot}/tools":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  
  file { "${webroot}/tools/7z1805.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/7z1805.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/7z1805-x64.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/7z1805.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/FileZilla_3.33.0_win32-setup_bundled.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/FileZilla_3.33.0_win32-setup_bundled.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/FileZilla_3.33.0_win64-setup_bundled.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/FileZilla_3.33.0_win64-setup_bundled.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/transmission-2.94-x64.msi":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/transmission-2.94-x64.msi",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  file { "${webroot}/tools/transmission-2.94-x86.msi":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/transmission-2.94-x86.msi",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/tools/HexChat_2.14.1_x86.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/HexChat_2.14.1_x86.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  file { "${webroot}/tools/HexChat_2.14.1_x64.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/HexChat_2.14.1_x64.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  file { "${webroot}/tools/WinCDEmu-4.1.exe":
    ensure  => 'present',
    source  => "puppet:///modules/gameserver/webroot/tools/WinCDEmu-4.1.exe",
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
}
