# puppet-lanserver
Puppet module to fully deploy all neccesarry services to run a LAN party at any size with ease

The following components are included
* DHCP - [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
* DNS - [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
* FTP Server for easy user uploads - [vsftpd](https://security.appspot.com/vsftpd.html)
* BitTorrent tracker - [opentracker](http://erdgeist.org/arts/software/opentracker/)
* Torrent Client - [transmission](http://transmissionbt.com/)
* Webserver - [Apache httpd](https://httpd.apache.org/)
* IRC Server [ngircd](https://ngircd.barton.de/index.php.en)
* IRC Webgui [kiwiirc](https://kiwiirc.com/)
* [inotify-tools](https://mirrors.edge.kernel.org/pub/linux/kernel/people/rml/inotify/README)
* self-written bash scripts
    * monitor the upload directory of the FTP Server and create a torrent from it (inotify2announce)
    * creating a torrent including information on the LAN website (add\_game.sh)
    * cleanup old torrents and whitelist only available torrents from the website

## Features
* Automatically deploy an environment for a LAN party. Provide all neccesary network services and client tools via http
* User don't need to have knowledge about creating torrents. They simply create an archive of their software/game and upload it via FTP. The server watches for new completly uploaded files, creates a torrent for it, and adds it to his own torrent client for serving it. Then it puts the torrent file to the webservers /upload directory.
* Create your own Games list with an simple bash script "add\_game.sh". It automatically generates an entry in your websergers /games,html.
  The template directory for every game is located in "/var/www/template".

## Requirements
* CentOS >= 7, Other distributions will be supported in the future.
* Puppet >= 4, The install script for CentOS/RHEL will include puppet 5.
* an internet connection (to install the packages from the bash script).
* Enough disk space for the torrent contents. Depends on how much you want
  to serve


## Usage
1. Download the code to your server. For example with git.``git clone https://github.com/pseiler/puppet-lanserver``
1. Change into the puppet module directory ``cd lanserver/manifests``
1. Edit the params.pp to the values you like. This includes the admin account name and password, the server configuration, the device you want to configure your listening services, ...
1. Change back into the puppet-lanserver directory. Run ``bash pre_puppet.sh``
1. If the script run successfully, Every server component should be installed and running. It adds all neccessary repositories and runs puppet serverless via "puppet apply".
1. Now you can simply update your configuration with the command from output from "bash pre\_puppet.sh"

## Verifying everything is running
This lanserver features serveral type of services.
To have an easy overview if everything is running,
run ``lanserver status`` on the command line

**ENHANCE ME**

## ToDos
* interactive bash script to create a hiera template which overwrites parameters from params.pp
* add mumble server
* add etherpad
* add kiwiirc to autostart via systemd
* rewrite add\_game.sh to use a markup language like xml or use a littel database backend like sqlite
