#!/bin/bash

main() {
    source settings.cfg

    for camera in "${!cameras[@]}" 
    do
        cameraCopy
    done

    upload
    if ! isNight; then
        echo "executing remote server"
        executeRemote
    fi
}

function cameraCopy() {
    /usr/bin/curl -v "${cameras[$camera]}" --create-dirs -o $savePath$camera-$(/bin/date +%s).jpg
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' --remove-source-files $savePath $remoteServer:"$remoteImagePath"
}

function isNight() {
    [ "$(/usr/local/bin/sunwait civil poll $longitude $latitude)" == "NIGHT" ]
}

function executeRemote() {
    ssh -v $remoteServer screen -d -m $remoteScript
}

main "$@"
