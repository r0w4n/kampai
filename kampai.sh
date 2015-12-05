#!/bin/bash

main() {
    source settings.cfg
    epoch=`/bin/date +%s`

    if isNightTime ; then
        echo "exiting..."
        exit
    fi

    for camera in "${!cameras[@]}"
    do
        capture $camera
    done

    upload
    executeRemote
}

function upload() {
    /usr/bin/rsync -avzhe ssh --include '*.jpg' --exclude '*' --remove-source-files $savePath $remoteServer:"$remoteImagePath"
}

function executeRemote() {
    ssh $remoteServer screen -d -m $remoteScript
}

function capture() {
    camera=$1
    /usr/bin/avconv -i rtsp://${cameras[$camera]} -frames:v 1 -f image2 -vf scale=960:-1 -qscale:v 2 $savePath$camera-$epoch.jpg
}

function isNightTime() {
    now=`/bin/date -d "+30 minutes"  +%H%M`

    if [ $now -gt $(getSunset) -o $now -lt $(getSunrise) ]; then
        return 0
    fi

    return 1
}

function getSunrise() {
    /usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<=Sun rises )(\d+)'
}

function getSunset() {
    /usr/bin/sunwait -p $longitude $latitude | /bin/grep -Po '(?<=sets )(\d+)'
}

main "$@"
