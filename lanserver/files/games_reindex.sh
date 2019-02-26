#!/bin/bash
# UNDER PUPPET CONTROL - MODIFICATIONS WILL BE OVERWRITTEN

if [ $UID -ne 0 ];
then
    echo "This script needs to be run as root";
    exit 1;
fi

SCRIPT_NAME="${0}";
CLICK_CLACK=0;

source /etc/sysconfig/lan_server

my_help(){
    echo "";
    echo "Usage: ${0} [OPTION...]";
    echo "When option is not given, it will ask in interactive mode";
    echo "";
    echo "-a \"short info\"       Can be a short sentence in \"\"";
    echo "-f /path/to/file      file or directory to make a torrent from";
    echo "-g \"Game name\"        human readable Name of the game in \"\"";
    echo "-p \"plattform\"        the operating system the game runs on";
    echo "-s server.name:9091   socket address for the dedicated server";
    echo "-t /path/to/template  the operating system the game runs on";
    echo "-v v1.0               software version of the game";
}

if [ -z "${TEMPLATE_DIR}" ];
then
    TEMPLATE_DIR="<%= $template_root %>";
fi;

if [ ! -d "${TEMPLATE_DIR}" ];
then
    echo "Template dir not found";
    echo "\"${TEMPLATE_DIR}\""
    echo "Please create this directory manually";
    exit 1;
fi

cat "${TEMPLATE_DIR}/header.html" > "${WEB_ROOT}/games.html";
cat "${TEMPLATE_DIR}/legend.html" >> "${WEB_ROOT}/games.html";
for i in ${TEMPLATE_DIR}/game_*.html;
do
   cat ${i} >> "${WEB_ROOT}/games.html";
done
echo "</table>" >> "${WEB_ROOT}/games.html";
cat "${TEMPLATE_DIR}/footer.html" >> "${WEB_ROOT}/games.html";
echo "Successfully recreated \"games.html\"";
exit 0;
