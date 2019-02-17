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
