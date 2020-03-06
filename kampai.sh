#!/bin/bash

main() {
    source settings.cfg
    epoch=$(/bin/date +%s)
    saveDir=$backupPath$(/bin/date +"%d-%m-%Y")/

    for camera in "${!cameras[@]}" 
    do
        cameraCopy
    done

    if ! hasSunSet; then
        upload
        executeRemote
    fi
}

function cameraCopy() {
    /usr/bin/curl "${cameras[$camera]}" --create-dirs -o $saveDir$camera-$epoch.jpg
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' $saveDir $remoteServer:"$remoteImagePath"
}

function hasSunSet() {
    if [ "$(/usr/local/bin/sunwait civil poll $longitude $latitude)" == "NIGHT" ]; then
        return 0
    fi

    return 1
}

function executeRemote() {
   ssh $remoteServer screen -d -m $remoteScript
}

main "$@"
