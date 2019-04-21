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
    * creating a torrent including information on the LAN website (``add_game.sh``)
    * cleanup old torrents and whitelist only available torrents from the website

## Features
* Automatically deploy an environment for a LAN party. Provide all neccesary network services and client tools via http
* Share prepared games via torrent. Use a easy-to-use script ``add_game.sh``to create an entry in your websergers */games.html* and add a local file or **directory**.
* Users can upload an archive via FTP and the server creates a **torrent** file for it and shares the content with with it's own client.
* Create your own Games list with a simple bash script *add\_game.sh*. It automatically generates an entry in your webservers */games.html*.
  The template directory for every game is located in */var/www/template*.

## Requirements
* **CentOS** >= 7, Other distributions will be supported in the future.
* **Puppet** >= 4, The install script for CentOS/RHEL will include puppet 5.
* an internet connection (to install the packages from the bash script).
* Enough disk space for the torrent contents. Depends on how much you want
  to serve.

Everything data-related is located somewhere in ***/var*** by default. So it's recommended that you add an additional partition mounted on ***/var***.

### Caution
Please don't start the dnsmasq server in a network, which already has a DHCP server. Things could go wrong.
And the hole torrent tracker part doesn't working without DNS.

## Setting the language
The lanserver website is currently available in two languages.
To switch it edit the *lanserver/manifests/params.pp* **lang** parameter and reapply the module to the server.
### translate the website
If you want to translate the website, copy the *en* directory in *lanserver/files/webroot/* and translate the whole content of *index.html*, *torrent.html* and *tech.html*.
You also need to add language vars to *lanserver/manifests/webroot.pp* for your specific language code. Two letters are allowed.

## Enable or disable specific services
Every service mentioned above can be managed independently. Enable or disable the services via *lanserver/manifests/params,pp*

## Usage / Installation
1. Download the code to your server. For example with git.``git clone --recursive https://github.com/pseiler/puppet-lanserver``
1. Change into the puppet module directory ``cd lanserver/manifests``
1. Edit the **lanserver/manifests/params.pp** to the values you like. This includes the admin account name and password, the server configuration, the device you want to configure your listening services, ...</br>Don't forget to set the right interface found from ``ip addr show``.
1. Change back into the puppet-lanserver directory. Run ``bash install_server.sh`` as root.
    * This script adds every requirement and installs every server component enabled by a a simple puppet **lanserver/manifests/params.pp** parameter.
    * If the script runs successfully every service should be running except *dnsmasq*.
1. Reboot your system when the script successfully deployed the puppet module. Caution! The DHCP Server starts after the next reboot.

## Verifying everything is running
This lanserver features serveral type of services.
To have an easy overview if everything is running,
run ``lanserver status`` on the command line
To stop/start everything use
``lanserver start``
or
``lanserver stop``

## Controlling services
Every service running is controlled by systemd.
Check the specific service or use the controller script
"lanserver" to start or stop all lanserver services.

## Add Games to games.html
To add a new game, or just add a new plattform for a game, just run ``game_add.sh``. You can find every parameter of the script when calling it with the **-h** parameter.
Every parameter except **-f** is optional and will be asked interactively. The file or directory must already exist somewhere on this server. So you need to transfer the game/application file or directory manually via scp or something else.

The snippet files you generated with this script are located in */var/www/template* by default. It's a bit ugly but perhaps this part will be rewritten with a database-like backend.
If needed, you can modify the \*.html snippets with the editor of your choice.
If you have changed something manually in in a html snippet in */var/www/template* just run ``games_reindex.sh`` to create a new *games.html* in the webservers directory.


## Forwarding Internet from another device
If your device has two interfaces, you can use a bash script called ``nat_control.sh`` to enable NAT forwarding/masquerading to the LAN network.
It only has two options (enable/disable) and when calling it with ***enable*** you must provide the device which has internet access. It depends on your configuration of interfaces.

Example:
```bash
root# nat_control.sh enable eth1
```

## Contributing
If you want to add a component to the puppet module, just create a new <component>.pp to the ``lanserver/manifests/`` directory and write some puppet code. If you want to add support for more distributions, modify the ``install_server.sh`` file and add a function which checks requirements as repositories for packages, etc. Don't forget to check the module code for distribution-specific paths and add a conditional statement for it.

## ToDos
* interactive bash script to create a hiera template which overwrites parameters from params.pp
* add mumble server
* add etherpad support
* add kiwiirc to autostart via systemd
* rewrite ``add_game.sh`` to use a markup language like *.xml* or use a little database backend like sqlite
* add a list/searching feature to ``add_game.sh``. Output html snipet when found.
* let the "lanserver" script enable NAT and disable it again, when it's running
* Make code more portable to support more distributions like Debian, Ubuntu and openSUSE
* Support other solutions for the admin to upload a game to the server except ssh/scp. Something like uploading a file/directory via non-anonymous ftp user.
* search for a better solution to translate titles of the website in webroot.pp. Consider a own class containting the language variables or something.
* Add information about bridging from a vm
