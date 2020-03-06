#!/bin/bash

main() {
    source settings.cfg
    epoch=$(/bin/date +%s)
    saveDir=$backupPath$(/bin/date +"%d-%m-%Y")/

    if hasSunSet; then
        echo "passed sunset, exiting..."
        exit
    fi

    /bin/mkdir -p $saveDir
    for camera in "${!cameras[@]}" 
    do
        cameraCopy $camera $saveDir
    done

    upload $saveDir
    executeRemote
}

function cameraCopy() {
    /usr/bin/wget -O $saveDir$camera-$epoch.jpg "${cameras[$camera]}"
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
