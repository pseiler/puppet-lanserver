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

check_plattform() {
    MY_INPUT="${1}";
    CLICK_CLACK=1;
    while [ $CLICK_CLACK -ne 0 ];
    do
        if [[ ${MY_INPUT,,} =~ "linux" ]];
        then
            MY_PLATTFORM="Linux";
            CLICK_CLACK=0;
        elif [[ ${MY_INPUT,,} =~ "windows" ]]
        then
            MY_PLATTFORM="Windows";
            CLICK_CLACK=0;
        elif [[ ${MY_INPUT,,} =~ "macos" ]]
        then
            MY_PLATTFORM="MacOS";
            CLICK_CLACK=0;
        elif [[ ${MY_INPUT,,} =~ "multi" ]]
        then
            MY_PLATTFORM="Multi";
            CLICK_CLACK=0;
        else
            echo "Only Windows, Linux, MacOS and Multi supported";
            echo "Please try again.";
            read MY_INPUT;
        fi;
    done;
}
generate_table_legend(){
    # creating the creating a html h3 heading and table descriptions
    DESTDIR="${TEMPLATE_DIR}/legend.html";
    echo "<table>" > "${DESTDIR}"
    echo "<tr>" >> "${DESTDIR}";
    echo "<th>Name" >> "${DESTDIR}";
    echo "<th>Operating System" >> "${DESTDIR}";
    echo "<th>Version</th>" >> "${DESTDIR}";
    echo "<th>HowTo</th>" >> "${DESTDIR}";
    echo "<th>Dedicated Server</th>" >> "${DESTDIR}";
    echo "<th>Additional Notes</th>" >> "${DESTDIR}";
    echo "</tr>" >> "${DESTDIR}";
}
generate_table_line() {
    # creating html table line
    DESTDIR="${TEMPLATE_DIR}/${GAME_STRIPPED}_${1}.html";
    echo "<tr>" > "${DESTDIR}";
    echo "<td></td>" > "${DESTDIR}";
    echo "<td><a href=\"/torrent/${TORRENT_FILE}_${MY_PLATTFORM}.torrent\">${MY_PLATTFORM}</a></td>" >> "${DESTDIR}";
    echo "<td>${MY_VERSION}</td>" >> "${DESTDIR}";
    echo "<td><a href=\"/howto/${GAME_STRIPPED}_${MY_PLATTFORM}.txt\">Link</a></td>" >> "${DESTDIR}";
    echo "<td>${MY_DEDICATED}</td>" >> "${DESTDIR}";
    echo "<td>${MY_ADDITIONAL}</td>" >> "${DESTDIR}";
    echo "</tr>" >> "${DESTDIR}";
}
my_info(){
    echo "Create simple html snippets for a game";
    echo "You can add informations for three plattforms";
    echo "Windows, Linux and MacOS";

    echo "The script creates a *.torrent file for your"
    echo "mentioned directory or file. This file"
    echo "will be uploaded directly to the torrent client";
    echo "on this server. You only need to merge the new game";
    echo "with the -p"
}

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

while getopts "a:f:hg:p:s:t:v:" arg; do
  case $arg in
    h)
      my_help;
      exit 0; 
      ;;
    g)
      GAME_NAME=$OPTARG;
      ;;
    v)
      MY_VERSION=$OPTARG;
      ;;
    s)
      MY_DEDICATED=$OPTARG;
      ;;
    a)
      MY_ADDITIONAL=$OPTARG;
      ;;
    p)
      MY_PLATTFORM=$OPTARG;
      check_plattform "${MY_PLATTFORM}";
      ;;
    f)
      TORRENT_PATH="${OPTARG}";
      TORRENT_FILE=$(basename "${TORRENT_PATH}");
      ;;
    t)
      TEMPLATE_DIR="${OPTARG}";
      ;;

  esac
done

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

if [ -z ${TORRENT_PATH} ];
then
    echo "ERROR:"
    echo "No option -f used";
    echo "Please provide the path";
    echo "to the file you want to";
    echo "create a torrent for";
    exit 1;
fi

if [ ! -e "${TORRENT_PATH}" ];
then
    echo "file or directory doesn't exist:";
    echo "\"${TORRENT_PATH}\"";
    exit 1;
fi

if [ -z "${MY_PLATTFORM}" ];
then
    echo "Please enter the operation system the";
    echo "game works on:";
    read MY_PLATTFORM;
    check_plattform "${MY_PLATTFORM}";
fi;

if grep -i "${MY_PLATTFORM}" "${TEMPLATE_DIR}/game_${GAME_STRIPPED}.html"  &> /dev/null;
then
    echo "A torrent for this plattform already exists";
    echo "Do you want to overwrite it?";
    read MY_ANSWER;
    if [[ $MY_ANSWER =~ "no" ]];
    then
        echo "";
        echo "User aborted.";
        exit 0;
    fi;
fi;

# interactive mode for missing parameters
if [ -z "${GAME_NAME}" ];
then
    echo "No game name inserted";
    echo "Insert it now:";
    read GAME_NAME;
fi;
GAME_STRIPPED=$(echo "${GAME_NAME}" | xargs | sed 's/ /./g');

if [ -z "${MY_VERSION}" ];
then
    echo "Please enter the version of the Game:";
    read MY_VERSION;
fi;

if [ -z "${MY_DEDICATED}" ];
then
    echo "Please enter the address for the dedicated Server";
    echo "\"-\" if not available";
    read MY_DEDICATED;
fi;

if [ -z "${MY_ADDITIONAL}" ];
then
    echo "Please enter Additional informations:";
    read MY_ADDITIONAL;
fi;

generate_table_legend;
generate_table_line "${MY_PLATTFORM}";

echo "<tr>" > ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ><b>${GAME_NAME}</b></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "<td class=\"game_name\" ></td>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
echo "</tr>" >> ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html;
cat ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html >> ${TEMPLATE_DIR}/game_${GAME_STRIPPED}.html;
rm ${TEMPLATE_DIR}/${GAME_STRIPPED}_base.html

for i in Windows Linux MacOS Multi;
do
    if [ -f "${TEMPLATE_DIR}/${GAME_STRIPPED}_${i}.html" ];
    then
        cat "${TEMPLATE_DIR}/${GAME_STRIPPED}_${i}.html" >> ${TEMPLATE_DIR}/game_${GAME_STRIPPED}.html;
    fi;
done;

for i in header footer;
do
    if [ ! -f "${TEMPLATE_DIR}/${i}.html" ];
    then
        echo "HTML ${i} for games page not found:";
        echo "\"${TEMPLATE_DIR}/${i}.html\"";
        exit 1;
    fi
done;

cat "${TEMPLATE_DIR}/header.html" > "${WEB_ROOT}/games.html";
cat "${TEMPLATE_DIR}/legend.html" >> "${WEB_ROOT}/games.html";
for i in ${TEMPLATE_DIR}/game_*.html;
do
   cat ${i} >> "${WEB_ROOT}/games.html";
done
echo "</table>" >> "${WEB_ROOT}/games.html";
cat "${TEMPLATE_DIR}/footer.html" >> "${WEB_ROOT}/games.html";

# copy every available howto to destination directory
if [ ! -d "${WEB_ROOT}/howto" ];
then
    mkdir "${WEB_ROOT}/howto";
fi;
cp "${TEMPLATE_DIR}/howto/*.txt" "${WEB_ROOT}/howto/" &> /dev/null;

if [ -s "${TORRENT_ROOT}/${TORRENT_FILE}" ];
then
    echo "Game file/directory \"${TORRENT_FILE}\" already";
    echo "exists in \"${TORRENT_ROOT}/\"";
    echo "Do you want to delete it?";
    read MY_ANSWER;
    if [[ $MY_ANSWER =~ "no" ]];
    then
        echo "";
        echo "User aborted.";
        exit 0;
    else
        echo "Removing old torrent...";
        rm -r "${TORRENT_ROOT}/${TORRENT_FILE}";
    fi;
fi;
mv "${TORRENT_PATH}" "${TORRENT_ROOT}/"
chown -R transmission:transmission "${TORRENT_ROOT}/${TORRENT_FILE}"
transmission-create -t "$TRACKER_URL" -o "${TORRENT_ROOT}/${TORRENT_FILE}_${MY_PLATTFORM}.torrent" "${TORRENT_ROOT}/${TORRENT_FILE}"
MY_HASH=$(transmission-show "${TORRENT_ROOT}/${TORRENT_FILE}_${MY_PLATTFORM}.torrent" | grep Hash | xargs | cut -d" " -f2)
echo "$MY_HASH" >> /var/opentracker/whitelist
systemctl reload opentracker-ipv4.service
transmission-remote "${TRANSMISSION_FQDN}:${TRANSMISSION_PORT}" --auth "${USER}:${PASSWORD}" -a "${TORRENT_ROOT}/${TORRENT_FILE}_${MY_PLATTFORM}.torrent"
mv "${TORRENT_ROOT}/${TORRENT_FILE}_${MY_PLATTFORM}.torrent" "${WEB_ROOT}/torrent/${TORRENT_FILE}_${MY_PLATTFORM}.torrent"
chown apache:apache "${WEB_ROOT}/torrent/${TORRENT_FILE}_${MY_PLATTFORM}.torrent"
