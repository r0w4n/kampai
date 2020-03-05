#!/bin/bash

main() {
    source settings.cfg
    epoch=`/bin/date +%s`

    if hasSunSet; then
        echo "passed sunset, exiting..."
        exit
    fi

    for camera in "${!cameras[@]}"
    do
        cameraCopy $camera
    done

    executeRemote
}

function cameraCopy() {
    /usr/bin/wget -O $backupPath$camera-$epoch.jpg "${cameras[$camera]}"
    /usr/bin/scp $backupPath$camera-$epoch.jpg $remoteServer:$remoteImagePath
}

function hasSunSet() {
    if [ "$(/usr/local/bin/sunwait civil poll $longitude $latitude)" == "NIGHT" ]; then
        return 0
    fi

    return 1
}

function executeRemote() {
    ssh $remoteServer $remoteScript
}

main "$@"

