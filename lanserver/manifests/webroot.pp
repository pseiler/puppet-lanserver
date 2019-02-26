# Class lanserver::webroot
#
# This class deploys the several html files to run the website for the lan party
#

class lanserver::webroot (
  $webroot,
  $my_domain,
  $my_hostname,
  $template_dir,
  Boolean $enable_kiwiirc,
  Enum['en','de'] $lang
) {
  # setting names of the html header according to language
  if $lang == 'de' {
    $header_home   = 'Hauptseite'
    $header_games  = 'Spiele'
    $header_tools  = 'Programme'
    $header_upload = 'Uploads'
    $index_title   = 'Einstieg'
  } else {
    $header_home   = 'Home'
    $header_games  = 'Games'
    $header_tools  = 'Tools'
    $header_upload = 'Uploads'
    $index_title   = 'Introduction'
  }


  ## directory where the supported games are located
  file { "${webroot}/torrent":
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'apache',
    group   => 'apache',
    require => Package['httpd'],
  }
  ### index.html
  concat { "${webroot}/index.html":
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }

  concat::fragment { 'index_header':
    target  => "${webroot}/index.html",
    content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => $index_title, 'enable_kiwiirc' => $enable_kiwiirc, 'home' => $header_home, 'games' => $header_games, 'tools' => $header_tools, 'upload' => $header_upload,}),
    order   => 01,
  }

  concat::fragment { 'index_content':
    target => "${webroot}/index.html",
    source => "puppet:///modules/lanserver/webroot/${lang}/index.html",
    order  => 02,
  }

  ## tech.html
  concat { "${webroot}/tech.html":
    ensure  => 'present',
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  concat::fragment { 'tech_header':
    target  => "${webroot}/tech.html",
    content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Tech', 'enable_kiwiirc' => $enable_kiwiirc, 'home' => $header_home, 'games' => $header_games, 'tools' => $header_tools, 'upload' => $header_upload,}),
    order   => 01,
  }

  concat::fragment { "${webroot}/tech.html":
    target  => "${webroot}/tech.html",
    source => "puppet:///modules/lanserver/webroot/${lang}/tech.html",
    order  => 02,
  }
  ## torrent.thml
  concat { "${webroot}/torrent.html":
    ensure  => 'present',
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
  }
  
  concat::fragment { 'torrent_header':
    target  => "${webroot}/torrent.html",
    content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'BitTorrent', 'enable_kiwiirc' => $enable_kiwiirc, 'home' => $header_home, 'games' => $header_games, 'tools' => $header_tools, 'upload' => $header_upload,}),
    order   => 01,
  }

  concat::fragment { "${webroot}/torrent.html":
    target  => "${webroot}/torrent.html",
    source => "puppet:///modules/lanserver/webroot/${lang}/torrent.html",
    order  => 02,
  }
  
  ### header file for directory listing
  file { "${webroot}/header.html":
    ensure  => 'present',
    content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Files', 'enable_kiwiirc' => $enable_kiwiirc, 'home' => $header_home, 'games' => $header_games, 'tools' => $header_tools, 'upload' => $header_upload,}),
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
   content => epp('lanserver/header.html.epp', {'hostname' => $my_hostname, 'domain' => $my_domain, 'title' => 'Games', 'enable_kiwiirc' => $enable_kiwiirc, 'home' => $header_home, 'games' => $header_games, 'tools' => $header_tools, 'upload' => $header_upload,}),
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
 
  file { "/usr/local/sbin/add_game.sh":
    ensure => 'present',
    source => 'puppet:///modules/lanserver/add_game.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
 
  file { "/usr/local/sbin/games_reindex.sh":
    ensure => 'present',
    source => 'puppet:///modules/lanserver/games_reindex.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
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
