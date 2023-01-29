#!/bin/bash

main() {
    source "${BASH_SOURCE%/*}/settings.cfg"

    if isNight; then
        echo "nighttime, exiting..."
        exit
    fi

    for camera in "${!cameras[@]}"
    do
        cameraCopy
    done

    upload
    executeRemote
}

function cameraCopy() {
    /usr/bin/curl -v "${cameras[$camera]}" --create-dirs -o $savePath$camera-$(/bin/date +%s).jpg
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' --remove-source-files $savePath $remoteServer:"$remoteI$
}

function isNight() {
    [ "$(/usr/local/bin/sunwait civil poll $longitude $latitude)" == "NIGHT" ]
}

function executeRemote() {
    ssh -v $remoteServer screen -d -m $remoteScript
}

main "$@"
