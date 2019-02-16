#!/bin/bash
MY_HOME="/home/kiwi"
KIWI_DIR="${MY_HOME}/kiwiirc"
tar -xf ${KIWI_DIR}/KiwiIRC.tar.gz -C ${KIWI_DIR} --strip-components=1
cd ${KIWI_DIR}
npm install
./kiwi build
./kiwi restart
