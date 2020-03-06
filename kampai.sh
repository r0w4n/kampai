#!/bin/bash

main() {
    source settings.cfg
    epoch=`/bin/date +%s`
    saveDir=$backupPath$(date +"%d-%m-%Y")/

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
    camera=$1
    saveDir=$2

    /usr/bin/wget -O $saveDir$camera-$epoch.jpg "${cameras[$camera]}"
}

function upload() {
    saveDir=$1
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' $saveDir $remoteSer$
}

function hasSunSet() {
    if [ "$(/usr/local/bin/sunwait civil poll $longitude $latitude)" == "NIGHT" ]$
        return 0
    fi

    return 1
}

function executeRemote() {
   ssh $remoteServer screen -d -m $remoteScript
}

main "$@"
